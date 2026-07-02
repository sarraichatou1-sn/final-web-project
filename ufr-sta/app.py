from flask import Flask, render_template, request, redirect, url_for, session, flash
import pymysql
from functools import wraps

app = Flask(__name__)
app.secret_key = 'ufr_sta_secret_key_2026'

# ─────────────────────────────────────────
# CONFIGURATION MYSQL
# ─────────────────────────────────────────

DB_CONFIG = {
    'host':     'localhost',
    'user':     'root',
    'password': '',          # Mot de passe MySQL (vide par défaut sur XAMPP)
    'database': 'ufr_sta',
    'charset':  'utf8mb4',
    'cursorclass': pymysql.cursors.DictCursor  # Résultats en dictionnaire
}

def get_db():
    """Ouvre une connexion MySQL."""
    return pymysql.connect(**DB_CONFIG)

def query_db(sql, args=()):
    """Exécute un SELECT et retourne tous les résultats."""
    conn = get_db()
    with conn.cursor() as cur:
        cur.execute(sql, args)
        result = cur.fetchall()
    conn.close()
    return result

def query_one(sql, args=()):
    """Exécute un SELECT et retourne un seul résultat."""
    conn = get_db()
    with conn.cursor() as cur:
        cur.execute(sql, args)
        result = cur.fetchone()
    conn.close()
    return result

def execute_db(sql, args=()):
    """Exécute un INSERT / UPDATE / DELETE."""
    conn = get_db()
    with conn.cursor() as cur:
        cur.execute(sql, args)
    conn.commit()
    conn.close()

# ─────────────────────────────────────────
# DÉCORATEUR ADMIN
# ─────────────────────────────────────────

def login_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if 'admin_logged_in' not in session:
            flash('Veuillez vous connecter.', 'warning')
            return redirect(url_for('admin_login'))
        return f(*args, **kwargs)
    return decorated

# ─────────────────────────────────────────
# ROUTES PUBLIQUES
# ─────────────────────────────────────────

@app.route('/')
def index():
    actualites = query_db('SELECT * FROM actualites ORDER BY date DESC LIMIT 3')
    activites  = query_db('SELECT * FROM activites  ORDER BY date DESC LIMIT 3')
    return render_template('index.html', actualites=actualites, activites=activites)

# — Départements
@app.route('/departements')
def departements():
    deps = query_db('SELECT * FROM departements ORDER BY nom')
    return render_template('departements.html', departements=deps)

@app.route('/departements/<int:dep_id>')
def departement_detail(dep_id):
    dep        = query_one('SELECT * FROM departements WHERE id = %s', (dep_id,))
    formations = query_db('SELECT * FROM formations WHERE departement_id = %s', (dep_id,))
    if not dep:
        flash('Département introuvable.', 'danger')
        return redirect(url_for('departements'))
    return render_template('departement_detail.html', departement=dep, formations=formations)

# — Formations
@app.route('/formations')
def formations():
    data = query_db(
        '''SELECT f.*, d.nom AS departement_nom
           FROM formations f
           LEFT JOIN departements d ON f.departement_id = d.id
           ORDER BY f.niveau, f.nom'''
    )
    return render_template('formations.html', formations=data)

@app.route('/formations/<int:formation_id>')
def formation_detail(formation_id):
    formation = query_one('SELECT * FROM formations WHERE id = %s', (formation_id,))
    modules   = query_db(
        'SELECT * FROM modules_formation WHERE formation_id = %s ORDER BY semestre, ordre',
        (formation_id,)
    )
    if not formation:
        flash('Formation introuvable.', 'danger')
        return redirect(url_for('formations'))
    return render_template('formation_detail.html', formation=formation, modules=modules)

# — Actualités
@app.route('/actualites')
def actualites():
    data = query_db('SELECT * FROM actualites ORDER BY date DESC')
    return render_template('actualites.html', actualites=data)

@app.route('/actualites/<int:actu_id>')
def actualite_detail(actu_id):
    actu = query_one('SELECT * FROM actualites WHERE id = %s', (actu_id,))
    if not actu:
        return redirect(url_for('actualites'))
    return render_template('actualite_detail.html', actualite=actu)

# — Activités
@app.route('/activites')
def activites():
    data = query_db('SELECT * FROM activites ORDER BY date DESC')
    return render_template('activites.html', activites=data)

@app.route('/activites/<int:act_id>')
def activite_detail(act_id):
    act    = query_one('SELECT * FROM activites WHERE id = %s', (act_id,))
    photos = query_db('SELECT * FROM galerie_photos WHERE activite_id = %s', (act_id,))
    if not act:
        return redirect(url_for('activites'))
    return render_template('activite_detail.html', activite=act, photos=photos)

# — Galerie
@app.route('/galerie')
def galerie():
    albums = query_db('SELECT * FROM albums ORDER BY date DESC')
    return render_template('galerie.html', albums=albums)

# — Enseignants
@app.route('/enseignants')
def enseignants():
    data = query_db(
        '''SELECT e.*, d.nom AS departement_nom
           FROM enseignants e
           LEFT JOIN departements d ON e.departement_id = d.id
           ORDER BY e.nom'''
    )
    return render_template('enseignants.html', enseignants=data)

# — Contact
@app.route('/contact', methods=['GET', 'POST'])
def contact():
    if request.method == 'POST':
        execute_db(
            'INSERT INTO messages_contact (nom, email, sujet, message) VALUES (%s, %s, %s, %s)',
            (request.form['nom'], request.form['email'],
             request.form['sujet'], request.form['message'])
        )
        flash('Message envoyé avec succès !', 'success')
        return redirect(url_for('contact'))
    return render_template('contact.html')

# ─────────────────────────────────────────
# — ADMINISTRATION
# ─────────────────────────────────────────

@app.route('/admin/login', methods=['GET', 'POST'])
def admin_login():
    if request.method == 'POST':
        admin = query_one(
            'SELECT * FROM admins WHERE username = %s AND password = %s',
            (request.form['username'], request.form['password'])
        )
        if admin:
            session['admin_logged_in'] = True
            session['admin_username']  = request.form['username']
            flash('Connexion réussie !', 'success')
            return redirect(url_for('admin_dashboard'))
        flash('Identifiants incorrects.', 'danger')
    return render_template('admin/login.html')

@app.route('/admin/logout')
def admin_logout():
    session.clear()
    flash('Déconnecté.', 'info')
    return redirect(url_for('admin_login'))

@app.route('/admin')
@login_required
def admin_dashboard():
    stats = {
        'departements': query_one('SELECT COUNT(*) as n FROM departements')['n'],
        'formations':   query_one('SELECT COUNT(*) as n FROM formations')['n'],
        'actualites':   query_one('SELECT COUNT(*) as n FROM actualites')['n'],
        'activites':    query_one('SELECT COUNT(*) as n FROM activites')['n'],
        'albums':       query_one('SELECT COUNT(*) as n FROM albums')['n'],
        'messages':     query_one('SELECT COUNT(*) as n FROM messages_contact')['n'],
    }
    derniers_messages = query_db('SELECT * FROM messages_contact ORDER BY id DESC LIMIT 5')
    return render_template('admin/dashboard.html', stats=stats, derniers_messages=derniers_messages)

# ── Admin Départements ──

@app.route('/admin/departements')
@login_required
def admin_departements():
    deps = query_db('SELECT * FROM departements ORDER BY nom')
    return render_template('admin/departements.html', departements=deps)

@app.route('/admin/departements/ajouter', methods=['GET', 'POST'])
@login_required
def admin_departement_ajouter():
    if request.method == 'POST':
        execute_db(
            'INSERT INTO departements (nom, description, responsable, contact) VALUES (%s, %s, %s, %s)',
            (request.form['nom'], request.form['description'],
             request.form['responsable'], request.form['contact'])
        )
        flash('Département ajouté.', 'success')
        return redirect(url_for('admin_departements'))
    return render_template('admin/departement_form.html', dep=None)

@app.route('/admin/departements/modifier/<int:dep_id>', methods=['GET', 'POST'])
@login_required
def admin_departement_modifier(dep_id):
    dep = query_one('SELECT * FROM departements WHERE id = %s', (dep_id,))
    if request.method == 'POST':
        execute_db(
            'UPDATE departements SET nom=%s, description=%s, responsable=%s, contact=%s WHERE id=%s',
            (request.form['nom'], request.form['description'],
             request.form['responsable'], request.form['contact'], dep_id)
        )
        flash('Département modifié.', 'success')
        return redirect(url_for('admin_departements'))
    return render_template('admin/departement_form.html', dep=dep)

@app.route('/admin/departements/supprimer/<int:dep_id>')
@login_required
def admin_departement_supprimer(dep_id):
    execute_db('DELETE FROM departements WHERE id = %s', (dep_id,))
    flash('Département supprimé.', 'success')
    return redirect(url_for('admin_departements'))

# ── Admin Formations ──

@app.route('/admin/formations')
@login_required
def admin_formations():
    data = query_db(
        '''SELECT f.*, d.nom AS departement_nom
           FROM formations f LEFT JOIN departements d ON f.departement_id = d.id'''
    )
    return render_template('admin/formations.html', formations=data)

@app.route('/admin/formations/ajouter', methods=['GET', 'POST'])
@login_required
def admin_formation_ajouter():
    deps = query_db('SELECT * FROM departements ORDER BY nom')
    if request.method == 'POST':
        execute_db(
            '''INSERT INTO formations (nom, niveau, duree, conditions_admission, debouches, departement_id)
               VALUES (%s, %s, %s, %s, %s, %s)''',
            (request.form['nom'], request.form['niveau'], request.form['duree'],
             request.form['conditions_admission'], request.form['debouches'],
             request.form['departement_id'] or None)
        )
        flash('Formation ajoutée.', 'success')
        return redirect(url_for('admin_formations'))
    return render_template('admin/formation_form.html', formation=None, departements=deps)

@app.route('/admin/formations/modifier/<int:formation_id>', methods=['GET', 'POST'])
@login_required
def admin_formation_modifier(formation_id):
    formation = query_one('SELECT * FROM formations WHERE id = %s', (formation_id,))
    deps      = query_db('SELECT * FROM departements ORDER BY nom')
    if request.method == 'POST':
        execute_db(
            '''UPDATE formations SET nom=%s, niveau=%s, duree=%s,
               conditions_admission=%s, debouches=%s, departement_id=%s WHERE id=%s''',
            (request.form['nom'], request.form['niveau'], request.form['duree'],
             request.form['conditions_admission'], request.form['debouches'],
             request.form['departement_id'] or None, formation_id)
        )
        flash('Formation modifiée.', 'success')
        return redirect(url_for('admin_formations'))
    return render_template('admin/formation_form.html', formation=formation, departements=deps)

@app.route('/admin/formations/supprimer/<int:formation_id>')
@login_required
def admin_formation_supprimer(formation_id):
    execute_db('DELETE FROM formations WHERE id = %s', (formation_id,))
    flash('Formation supprimée.', 'success')
    return redirect(url_for('admin_formations'))

# ── Admin Actualités ──

@app.route('/admin/actualites')
@login_required
def admin_actualites():
    data = query_db('SELECT * FROM actualites ORDER BY date DESC')
    return render_template('admin/actualites.html', actualites=data)

@app.route('/admin/actualites/ajouter', methods=['GET', 'POST'])
@login_required
def admin_actualite_ajouter():
    if request.method == 'POST':
        execute_db(
            'INSERT INTO actualites (titre, date, description, photo, categorie) VALUES (%s, %s, %s, %s, %s)',
            (request.form['titre'], request.form['date'], request.form['description'],
             request.form['photo'], request.form['categorie'])
        )
        flash('Actualité publiée.', 'success')
        return redirect(url_for('admin_actualites'))
    return render_template('admin/actualite_form.html', actu=None)

@app.route('/admin/actualites/modifier/<int:actu_id>', methods=['GET', 'POST'])
@login_required
def admin_actualite_modifier(actu_id):
    actu = query_one('SELECT * FROM actualites WHERE id = %s', (actu_id,))
    if request.method == 'POST':
        execute_db(
            'UPDATE actualites SET titre=%s, date=%s, description=%s, photo=%s, categorie=%s WHERE id=%s',
            (request.form['titre'], request.form['date'], request.form['description'],
             request.form['photo'], request.form['categorie'], actu_id)
        )
        flash('Actualité modifiée.', 'success')
        return redirect(url_for('admin_actualites'))
    return render_template('admin/actualite_form.html', actu=actu)

@app.route('/admin/actualites/supprimer/<int:actu_id>')
@login_required
def admin_actualite_supprimer(actu_id):
    execute_db('DELETE FROM actualites WHERE id = %s', (actu_id,))
    flash('Actualité supprimée.', 'success')
    return redirect(url_for('admin_actualites'))

# ── Admin Activités ──

@app.route('/admin/activites')
@login_required
def admin_activites():
    data = query_db('SELECT * FROM activites ORDER BY date DESC')
    return render_template('admin/activites.html', activites=data)

@app.route('/admin/activites/ajouter', methods=['GET', 'POST'])
@login_required
def admin_activite_ajouter():
    if request.method == 'POST':
        execute_db(
            'INSERT INTO activites (titre, date, lieu, organisateur, description) VALUES (%s, %s, %s, %s, %s)',
            (request.form['titre'], request.form['date'], request.form['lieu'],
             request.form['organisateur'], request.form['description'])
        )
        flash('Activité publiée.', 'success')
        return redirect(url_for('admin_activites'))
    return render_template('admin/activite_form.html', act=None)

@app.route('/admin/activites/modifier/<int:act_id>', methods=['GET', 'POST'])
@login_required
def admin_activite_modifier(act_id):
    act = query_one('SELECT * FROM activites WHERE id = %s', (act_id,))
    if request.method == 'POST':
        execute_db(
            'UPDATE activites SET titre=%s, date=%s, lieu=%s, organisateur=%s, description=%s WHERE id=%s',
            (request.form['titre'], request.form['date'], request.form['lieu'],
             request.form['organisateur'], request.form['description'], act_id)
        )
        flash('Activité modifiée.', 'success')
        return redirect(url_for('admin_activites'))
    return render_template('admin/activite_form.html', act=act)

@app.route('/admin/activites/supprimer/<int:act_id>')
@login_required
def admin_activite_supprimer(act_id):
    execute_db('DELETE FROM activites WHERE id = %s', (act_id,))
    flash('Activité supprimée.', 'success')
    return redirect(url_for('admin_activites'))

# ── Admin Galerie ──

@app.route('/admin/galerie')
@login_required
def admin_galerie():
    albums = query_db('SELECT * FROM albums ORDER BY date DESC')
    return render_template('admin/galerie.html', albums=albums)

@app.route('/admin/albums/ajouter', methods=['GET', 'POST'])
@login_required
def admin_album_ajouter():
    if request.method == 'POST':
        execute_db(
            'INSERT INTO albums (titre, description, date, annee) VALUES (%s, %s, %s, %s)',
            (request.form['titre'], request.form['description'],
             request.form['date'] or None, request.form['annee'] or None)
        )
        flash('Album créé.', 'success')
        return redirect(url_for('admin_galerie'))
    return render_template('admin/album_form.html', album=None)

@app.route('/admin/albums/modifier/<int:album_id>', methods=['GET', 'POST'])
@login_required
def admin_album_modifier(album_id):
    album = query_one('SELECT * FROM albums WHERE id = %s', (album_id,))
    if request.method == 'POST':
        execute_db(
            'UPDATE albums SET titre=%s, description=%s, date=%s, annee=%s WHERE id=%s',
            (request.form['titre'], request.form['description'],
             request.form['date'] or None, request.form['annee'] or None, album_id)
        )
        flash('Album modifié.', 'success')
        return redirect(url_for('admin_galerie'))
    return render_template('admin/album_form.html', album=album)

@app.route('/admin/albums/supprimer/<int:album_id>')
@login_required
def admin_album_supprimer(album_id):
    execute_db('DELETE FROM galerie_photos WHERE album_id = %s', (album_id,))
    execute_db('DELETE FROM albums WHERE id = %s', (album_id,))
    flash('Album supprimé.', 'success')
    return redirect(url_for('admin_galerie'))

@app.route('/admin/albums/<int:album_id>/photos')
@login_required
def admin_album_photos(album_id):
    album  = query_one('SELECT * FROM albums WHERE id = %s', (album_id,))
    photos = query_db('SELECT * FROM galerie_photos WHERE album_id = %s', (album_id,))
    return render_template('admin/album_photos.html', album=album, photos=photos)

@app.route('/admin/albums/<int:album_id>/photos/ajouter', methods=['POST'])
@login_required
def admin_photo_ajouter(album_id):
    execute_db(
        'INSERT INTO galerie_photos (album_id, fichier, legende) VALUES (%s, %s, %s)',
        (album_id, request.form['fichier'], request.form.get('legende', ''))
    )
    flash('Photo ajoutée.', 'success')
    return redirect(url_for('admin_album_photos', album_id=album_id))

@app.route('/admin/photos/supprimer/<int:photo_id>')
@login_required
def admin_photo_supprimer(photo_id):
    album_id = request.args.get('album_id', type=int)
    execute_db('DELETE FROM galerie_photos WHERE id = %s', (photo_id,))
    flash('Photo supprimée.', 'success')
    return redirect(url_for('admin_album_photos', album_id=album_id))

# ─────────────────────────────────────────
# LANCEMENT
# ─────────────────────────────────────────

if __name__ == '__main__':
    app.run(debug=True)
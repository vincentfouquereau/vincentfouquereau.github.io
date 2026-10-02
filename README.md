# fouquereau-site

Site personnel de **Vincent Fouquereau** — mentor et stratège.
Site statique (HTML/CSS/JS purs), bilingue FR/EN, publié sur GitHub Pages à
l'adresse **https://www.fouquereau.com**.

## Aucune étape de build

Le contenu de ce dossier est déployé tel quel. Ouvrez simplement `index.html`
dans un navigateur pour prévisualiser localement, ou lancez un petit serveur :

```bash
python3 -m http.server 8000
# puis http://localhost:8000/
```

## Structure

```
index.html                 Accueil FR
index-en.html              Accueil EN
equation-humaine.html      Série Équation Humaine FR
equation-humaine-en.html   Série Human Equation EN
equation_humaine.html      Redirection (ancienne URL, noindex)
404.html                   Page introuvable
robots.txt / sitemap.xml   Référencement
site.webmanifest           Manifeste PWA (icônes, thème)
css/style.css              Feuille de style unique
js/main.js                 Menu mobile, carte au consentement, année
assets/fonts/              Inter Tight auto-hébergée (latin + latin-ext)
assets/img/                Images + variantes WebP, favicons, image Open Graph
deploy.sh                  Script de déploiement GitHub Pages
```

## Conventions

- Palette : primaire `#8db9c9`, fonds `#edefeb` / `#f7f7f7`, texte `#232323`,
  accent contact `#3f6473` (pour le contraste AA du texte blanc).
- Police : Inter Tight, auto-hébergée (aucune dépendance à Google Fonts).
- Les en-têtes/pied de page sont dupliqués dans chaque page : toute
  modification doit être reportée sur les 4 pages (+ `404.html` pour la nav).
- Chaque image possède ses variantes WebP avec `srcset` + `width`/`height`.

## Déploiement

```bash
GH_TOKEN=<PAT fine-grained, Contents: read/write> ./deploy.sh "Message de commit"
```

Ou avec le token stocké dans le trousseau (voir le skill `fouquereau-site-update`).
Le script clone le dépôt de déploiement, synchronise la source, commit et pousse
sur `main`, puis vérifie la mise en ligne.

> Ne jamais supprimer `CNAME` ni `README.md` du dépôt de déploiement
> (absents de cette source et gérés séparément).

## Historique des améliorations

- Correction du sélecteur de langue FR sur la page Équation Humaine.
- Accessibilité : lien d'évitement, `aria-current`, focus visible, contraste AA,
  `prefers-reduced-motion`.
- Performance : images WebP avec `srcset`, dimensions explicites, lazy-loading,
  polices auto-hébergées + préchargement.
- Vie privée/sécurité : CSP, carte Google chargée uniquement après consentement,
  `rel="noreferrer"`, `noindex` sur la redirection.
- SEO : canoniques, `hreflang`, Open Graph/Twitter, JSON-LD, favicons,
  robots.txt et sitemap.xml.

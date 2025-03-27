import os
import re

def nettoyer_nom(nom):
    # Sépare nom et extension
    nom_sans_ext, extension = os.path.splitext(nom)

    # Nettoyage comme dans Flutter
    nom_nettoye = (
        nom_sans_ext
        .lower()
        .replace(' ', '_')
        .replace('-', '_')
    )
    nom_nettoye = re.sub(r'[^a-z0-9_]', '', nom_nettoye)  # enlève les caractères spéciaux

    return nom_nettoye + extension.lower()


def renommer_images(dossier):
    for nom_fichier in os.listdir(dossier):
        ancien_chemin = os.path.join(dossier, nom_fichier)
        if os.path.isfile(ancien_chemin):
            nouveau_nom = nettoyer_nom(nom_fichier)
            nouveau_chemin = os.path.join(dossier, nouveau_nom)

            if ancien_chemin != nouveau_chemin:
                os.rename(ancien_chemin, nouveau_chemin)
                print(f"Renommé : {nom_fichier} → {nouveau_nom}")
            else:
                print(f"Déjà propre : {nom_fichier}")

# Exemple d’utilisation
dossier_images = "./"
renommer_images(dossier_images)

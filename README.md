# Tharunya Handbook

A practical, structured handbook of guides and explanations across engineering foundations, setup, concepts, and real system lessons.

## Start here
- Foundations: `content/foundations/`
- Setup: `content/setup/`
- Concepts: `content/concepts/`
- Systems: `content/systems/`

## Create a new doc
Use the generator script:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\new-doc.ps1 -Pillar foundations -Domain web -Title "Node vs Node.js"
Then write, commit, and open a PR.

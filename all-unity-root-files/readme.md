# Create

```bash
git init && git lfs install && git add . && git commit -m "initial"
```

Set new empty project repository url + push
```bash
git remote add origin {repository-url}
git push -u origin main
```

# Replace local lfs pointers with actual content

```bash
git lfs checkout
```

# Add new files to LFS

```bash
git lfs track "/Assets/**/NavMesh.asset"
git lfs track "/Assets/**/*NavMesh.asset"
git lfs track "/Assets/**/*NavMesh*.asset"
git lfs track "/Assets/**/NavMesh*.asset"

git lfs track "/Assets/**/navmesh.asset"
git lfs track "/Assets/**/*navmesh.asset"
git lfs track "/Assets/**/*navmesh*.asset"
git lfs track "/Assets/**/navmesh*.asset"

git add --renormalize .
git commit -m "store navmeshes in LFS"
```

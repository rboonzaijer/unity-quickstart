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

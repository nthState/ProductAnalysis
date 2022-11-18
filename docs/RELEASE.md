## Deployment

### Creating a Release

To create a release, you need to add a tag, and push it.
GitHub Actions handle the rest.


```bash
git tag vx.x.x
```

Then push

```bash
git push origin vx.x.x   
```

#### If you make a mistake

Delete the tag, and start again

```
git tag -d vx.x.x
```

Then push the delete

```
git push --delete origin vx.x.x
```
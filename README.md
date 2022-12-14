USAGE

```bash
docker build -t android_bash_local --platform=aarch64 . \
&& docker run --rm --platform linux/aarch64 -v "$(pwd)":/target android_bash_local
```
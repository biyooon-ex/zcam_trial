# zcam_trial

Zenoh zcamデモのとらいある

全面的にめもなのでpublic化の予定なし:D

## Docker環境の使用方法

最終的にUbuntu22 (on RPi4/5 or Azure) でいごかすつもり（とはいってない？？

### パッケージ

- ubuntu22
- Zenoh 0.11.0
- Python 3.10.12
- OpenCV 4.5.4

### 使用方法

```
docker compose up -d
docker compose exec /bin/bash zcam_docker
```

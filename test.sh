
#!/usr/bin/env sh
crystal sorted.cr --release && sleep 2s && rdmd sorted.d --release && sleep 2s && node sorted.js && sleep 2s && python sorted.py

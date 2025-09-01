#!/usr/bin/env python3
import sys, json, struct, subprocess, platform, os

home_dir = os.path.expanduser("~")

def read_message():
    raw_len = sys.stdin.buffer.read(4)
    if len(raw_len) == 0:
        return None
    msg_len = struct.unpack("<I", raw_len)[0]
    msg = sys.stdin.buffer.read(msg_len).decode("utf-8")
    return json.loads(msg)

def write_message(obj):
    data = json.dumps(obj).encode("utf-8")
    sys.stdout.buffer.write(struct.pack("<I", len(data)))
    sys.stdout.buffer.write(data)
    sys.stdout.flush()

def brave_cmd(url):
    system = platform.system()
    if system == "Darwin":
        path = "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
        return [path, "--new-window", url]
    elif system == "Windows":
        paths = [
            os.path.join(home_dir, r"AppData\Local\BraveSoftware\Brave-Browser\Application\brave.exe"),
            r"C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe",
            r"C:\Program Files (x86)\BraveSoftware\Brave-Browser\Application\brave.exe"
        ]
        for p in paths:
            if os.path.exists(p):
                # return [p, "--new-window", url]
                return [p, url]
        return ["brave.exe", "--new-window", url]
    else:
        return ["brave-browser", "--new-window", url]

def allowed(url: str) -> bool:
    return url.startswith("http://") or url.startswith("https://")

def main():
    while True:
        msg = read_message()
        if msg is None:
            break
        url = msg.get("url", "")
        if not allowed(url):
            write_message({"ok": False, "error": "Only http(s) URLs allowed."})
            continue
        try:
            subprocess.Popen(brave_cmd(url))
            write_message({"ok": True})
        except Exception as e:
            write_message({"ok": False, "error": str(e)})

if __name__ == "__main__":
    main()

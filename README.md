# practice-automation

Run the entire practice bundle analysis in **one command**, safely containerised with Docker.

---

## ✨ Features

| Task                            | What it does                                                                 |
| ------------------------------- | ---------------------------------------------------------------------------- |
| **Top‑3 largest files**         | Finds and lists the three biggest files in the bundle.                       |
| **404 requests**                | Extracts every web‑server request that returned 404 (Not Found).             |
| **sshd ERROR counts**           | Counts `ERROR` messages per SSHD process ID in `syslog.log`.                 |
| **Backup**                      | Executes `scripts/backup.sh` inside the container using `rsync`.             |
| **SQLite import & city counts** | Imports `data/customers.csv` into SQLite and outputs per‑city counts to CSV. |

All resulting artefacts land in an **`automated_output/`** folder next to your bundle.

---

## 🏃‍♂️ Quick start

```bash
# Pull the latest image
docker pull ghcr.io/kentex99/practice-automation:latest

# Run against a bundle folder on your host
#     (replace /path/to/bundle with your real path)

docker run --rm \
  -v /path/to/bundle:/data \
  ghcr.io/kentex99/practice-automation /data
```

The script prints progress like `[1/5] …` `[5/5] …` and saves results under `/data/automated_output`.

---

## 📦 Image tags

| Tag      | Purpose                                   |
| -------- | ----------------------------------------- |
| `latest` | Always the most recent build from `main`. |
| `0.1.0`  | First stable release (pinned).            |

Use a specific version tag in CI for reproducible builds, e.g.:

```bash
docker pull ghcr.io/kentex99/practice-automation:0.1.0
```

---

## 🔧 Environment & volumes

| Path in container        | Notes                                                                        |
| ------------------------ | ---------------------------------------------------------------------------- |
| `/data` (argument)       | **Required** – mount your bundle here and pass the same path as an argument. |
| `/data/automated_output` | Created by the script; contains logs, `customers.db`, CSVs, etc.             |

The container writes nothing outside `/data`.

---

## 🛠️ Dependencies inside the image

* `sqlite3` – for CSV → SQLite import.
* `rsync` – used by `backup.sh`.
* Standard GNU utilities (`find`, `awk`, `grep`, `sort`, …) from Ubuntu 24.04.

---

## 📝 License

MIT © 2025 kenneth tas.

---

## 🙋 Questions / Issues

*File an issue on the **[GitHub repo](https://github.com/kentex99/practice-automation/issues)** or open a discussion.*

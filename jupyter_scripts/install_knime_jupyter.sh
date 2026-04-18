#!/usr/bin/env bash
set -euo pipefail

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y \
  dbus-x11 \
  xfce4 \
  xfce4-panel \
  xfce4-session \
  xfce4-settings \
  xorg \
  xubuntu-icon-theme \
  tigervnc-standalone-server \
  wget \
  tar

pip3 install jupyter-remote-desktop-proxy

mkdir -p "$HOME/apps" "$HOME/downloads" "$HOME/.vnc" "/workspace/knime-workflows"

cat > "$HOME/.vnc/xstartup" <<'EOF'
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec dbus-launch --exit-with-session xfce4-session
EOF

chmod +x "$HOME/.vnc/xstartup"

mkdir -p ~/apps ~/downloads
cd ~/downloads
KNIME_URL="https://download.knime.com/analytics-platform/linux/knime_5.11.0.linux.gtk.x86_64.tar.gz"
wget -O knime.tar.gz "$KNIME_URL"
tar -xzf knime.tar.gz -C ~/apps

cd /workspace
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O Miniforge3.sh
bash Miniforge3.sh -b -p /root/miniforge3
source /root/miniforge3/bin/activate
conda create -y -n knime-dl python=3.11
conda activate knime-dl
pip install ipython nbformat scipy numpy pandas scikit-learn jupyterlab

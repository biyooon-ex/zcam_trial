# zcam_trial

Zenoh zcamデモのとらいある

## 必要なツール・バージョン

- [zenoh 0.11.0](https://github.com/eclipse-zenoh/zenoh/releases/tag/0.11.0)
- opencv 4.5.4 (e.g. `apt install libopencv-dev`)
- asdf v0.14.0
- erlang 26.2.5
- elixir 1.16.3-otp-26
- Python 3
  - pip: eclipse-zenoh==0.11.0, opencv-python, numpy, imutils

ローカルPCでは適宜でインストール，リモート先にクラウドVMを使う場合には下記のAnsibleで環境構築可能．

## Ansibleでのリモート先サーバの環境構築

### ローカルPCの設定

- ローカルPCにAnsibleのインストール https://docs.ansible.com/ansible/2.9_ja/installation_guide/intro_installation.html
  - macOS環境だとpipでインストール
    ```
    source ~/.venv/bin/activate
    pip install ansible
    ```
  - Ubuntuの場合
    ```
    sudo apt update
    sudo apt install software-properties-common
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt install ansible
    ```
- `~/.ssh/config` の設定
  ```
  Host biyooon_cloud
    HostName x.x.x.x
    User azureuser
    Port 22
    IdentityFile ~/.ssh/hogehoge.pem
  ```
  - inventory fileに書くのが公式推奨？だが，特にIPアドレスをGitHub管理にしたくないので本方法を用いることにする．
- 疎通確認
  ```
  % ansible all -i ansible/inventory.yml -m ping
  biyooon_cloud | SUCCESS => {
      "ansible_facts": {
          "discovered_interpreter_python": "/usr/bin/python3.10"
      },
      "changed": false,
      "ping": "pong"
  }
  ```
  - Python関係の`[WARNING]`が出ても気にしないことにする．
- Zenoh通信のため，ネットワーク設定 > ネットワークセキュリティグループ に移動し，受信/送信の双方のセキュリティ規則 に下記を「宛先ポート範囲」として「許可」で`7447`を追加する（TODO：要否を検証） 

### 環境構築 on VM by ansible

ローカルPCで下記を実行

```
cd ansible
ansible-playbook -i inventory.yml zenoh-playbook.yml
ansible-playbook -i inventory.yml asdf-playbook.yml
```

## Zcamの動作手順

### ローカルPCのみでの動作

PythonのためローカルPCでは適宜で `source ~/.venv/bin/activate` あたりを実行しておく．

ElixirのためMixプロジェクトをビルドしておく．
```
cd zcam_elixir
mix deps.get
mix compile
```

3つのターミナルを開いてそれぞれ下記を実行する．

- Ping側：
  - Pythonの場合
    ```
    cd zcam-python
    python3 zcapture.py --ping-key demo/zcam/ping
    ```
  - Elixirの場合
    ```
    cd zcam_elixir
    iex -S mix
    iex()> ZcamElixir.zcapture("demo/zcam/ping")
    ```
- Echo側：
  - Pythonの場合
    ```
    cd zcam-python
    python3 zecho.py --ping-key demo/zcam/ping --pong-key demo/zcam/pong
    ```
  - Elixirの場合
    ```
    cd zcam_elixir
    iex -S mix
    iex()> ZcamElixir.zecho("demo/zcam/ping", "demo/zcam/pong")
    ```
- Pong側：
  - Pythonの場合
    ```
    cd zcam-python
    python3 zdisplay.py --pong-key demo/zcam/pong
    ```
  - Elixirは未実装

### クラウドを仲介した動作

ローカルPCでは，2つのターミナルを開いてそれぞれ下記を実行する．

- Ping側：
  - Pythonの場合
    ```
    cd zcam-python
    python3 zcapture.py --ping-key demo/zcam/ping -e tcp/<x.x.x.x>:7447
    ```
  - Elixirの場合
    ```
    cd zcam_elixir
    iex -S mix
    iex()> ZcamElixir.zcapture("demo/zcam/ping", "tcp/<x.x.x.x>:7447")
    ```
- Pong側：
  - Pythonの場合
    ```
    cd zcam-python
    python3 zdisplay.py --pong-key demo/zcam/pong -e tcp/<x.x.x.x>:7447
    ```
  - Elixirは未実装

クラウドでは，まずこのリポジトリをcloneしておく

```
cd ~
git clone https://github.com/biyooon-ex/zcam_trial
```

その後，2つのターミナルを開いてそれぞれ下記を実行する．

- Zenohルータ：
  ```
  zenohd
  ```
- Echo側：
  - Pythonの場合
    ```
    cd ~/zcam_trial/zcam-python
    python3 zecho.py
    ```
  - Elixirの場合
    ```
    cd ~/zcam_trial/zcam_elixir
    iex -S mix
    iex()> ZcamElixir.zecho("demo/zcam/ping", "demo/zcam/pong")
    ```

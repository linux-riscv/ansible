# Ansible playbooks for the linux-riscv infra

!! Not complete !!

Manually create machines:
```
hcloud server create --name rise-controller-1 --type SERVER-TYPE??? \
   --image ubuntu-24.04 --ssh-key bjorn@rivosinc.com

hcloud server create --name rise-linux-kernel-ci-1 --type ccx63 \
   --image ubuntu-24.04 --ssh-key bjorn@rivosinc.com

```

Copy `secrets.yml.example` to `secrets.yml` and insert patchwork, and
github tokens.

```
# Assume KPD runs on host $KPD and a runner on $RUNNER

$ ansible-playbook -i $KDP, -u root ./playbooks/kernel-patches-daemon.yml
$ ansible-playbook -i $RUNNER, -u root ./playbooks/github-runner-ephemeral.yml

```

Manually on KDP:
```
systemctl start pwsyncher
```

Manually on RUNNER(s):
```
su github
cd ~/actions-runner
export GH_TOKEN="mysecretsoken"
./ghrunner.sh
```

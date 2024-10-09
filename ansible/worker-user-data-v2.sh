#!/bin/bash

#esse script visa instalar os pacotes e outros recursos informados no ansible para quando
#o autoscaler lancar uma nova instancia ja venha com esses recursos, favorecendo a 
#comunicacao dentro do cluster autoscaler/kubernetes


function updateHostname(){
  hostnamectl set-hostname $(curl http://169.254.169.254/latest/meta-data/hostname)
}

function installSystemsManagerAgentOnEc2(){
  apt-get update

  if[! -d "/tmp/ssm"]; then
    mkdir -p /tmp/ssm
  fi
  cd /tmp/ssm
  if [!-f "amazon-ssm-agent.deb"]; then
  wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
  fi
  dpkg -i amazon-ssm-agent.deb
}

function installKubernetesDependencyPackages(){
  #dois comandos apt-get podera incorrer em erros de locking(a propria maquina esta rodando algum processo em paralelo
  #enquanto cria a instancia, usando este mesmo comando). eis o motivo pelo qual, lancaremos uma 
  #nova instrucao: -o DPKG::Lock::Timeout=5
      sleep 30
      apt-get update -o DPKG::Lock::Timeout=5 -y
      apt-get install -o DPKG::Lock::Timeout=5 -y apt-transport-https \
       ca-certificates \
       curl \
       gpg \
       software-properties-common
}

function installKubernetesPackages(){
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | \
   gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

   echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | \
    tee /etc/apt/sources.list.d/kubernetes.list

  apt-get update -o DPKG::Lock::Timeout=5 -y
  apt-get install -o DPKG::Lock::Timeout=5 -y kubelet kubeadm kubectl
  apt-mark hold kubelet kubeadm kubectl
}

function installContainerRuntime(){
curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/stable:/v1.30/deb/Release.key | \
    gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/stable:/v1.30/deb/ /" | \
    tee /etc/apt/sources.list.d/cri-o.list

apt-get update -o DPKG::Lock::Timeout=5 -y
apt-get install -o DPKG::Lock::Timeout=5 -y cri-o
systemctl start crio.service
sysctl -w net.ipv4.ip_forward=1
}

#dentro do cluster/linha de comando use o seguinte comando para obter o token para a funcao abaixo:
#kubeadm token create --print-join-command
#o comando exibira um dns com o nome do sistema + dns do nlb + porta, o token + hash sha
#a funcao abaixo ira vincular as novas instancias ao DNS do network load balancer.
function joinWorkerNodes(){
  #{{joinWorkerCommand}}
  #o comando e copiado para esta linha
  #kubeadm...........
}

#A essa altura, ele realiza um teste alterando o launch template original(dentro do console da aws)
#para ver o comportamento.

#comando para visualizar os logs: cat /var/log/cloud-init-output.log

updateHostname
installSystemsManagerAgentOnEc2
installKubernetesDependencyPackages
installKubernetesPackages
installContainerRuntime
joinWorkerNodes
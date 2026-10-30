#!/bin/bash
# PC USERNAME AND PASSWORD

export PC_ENDPOINT="https://<IP>:9440"
export NUTANIX_USER="admin"
export NUTANIX_PASSWORD=""

#Registry Details

# PE CLUSTER NAME AND CONTAINER

export PE_CLUSTER_NAME=Shivang-DR
export STORAGE_CONTAINER=Shivang-Stg

# MANAGEMENT CLUSTER NAME, IP AND SUBNET
export CLUSTER_NAME=nkp-mgmt-shivang
export CP_ENDPOINT_IP=<IP>
export SUBNET=<vlan>

export SSH_KEY_FILE="/root/.ssh/id_ed25519.pub"
export SSH_USER=<USER>

# LB RANGE, POD AND SVC NETWORK

export LB_RANGE=<LB-Range>
export POD_NET=""
export SVC_NET=""

# IMAGE FOR MASTER AND WORKER NODE AND CPV, MEMORY, DISK REPLICAS

export NKP_IMAGE=""

export CTR_DISK_SIZE=
export CTR_MEM=
export CTR_VCPU=
export CTR_REPLICAS=

export WORKER_DISK_SIZE=
export WORKER_MEM=
export WORKER_VCPU=
export WORKER_REPLICAS=

export OUTPUT=yaml
export VERBOSE=5

# export PROJECT=Shivang-Project-01
export BUNDLE=""

nkp create cluster nutanix \
--endpoint ${PC_ENDPOINT} \
--cluster-name ${CLUSTER_NAME} \
--control-plane-endpoint-ip ${CP_ENDPOINT_IP} \
--control-plane-prism-element-cluster ${PE_CLUSTER_NAME} \
--control-plane-subnets ${SUBNET} \
--control-plane-vm-image ${NKP_IMAGE} \
--control-plane-memory ${CTR_MEM} \
--control-plane-disk-size ${CTR_DISK_SIZE} \
--control-plane-vcpus ${CTR_VCPU} \
--control-plane-replicas ${CTR_REPLICAS} \
--worker-prism-element-cluster ${PE_CLUSTER_NAME} \
--worker-subnets ${SUBNET} \
--worker-vm-image ${NKP_IMAGE} \
--worker-disk-size ${WORKER_DISK_SIZE} \
--worker-memory ${WORKER_MEM} \
--worker-replicas ${WORKER_REPLICAS} \
--worker-vcpus ${WORKER_VCPU} \
${BUNDLE} \
--csi-storage-container ${STORAGE_CONTAINER} \
--kubernetes-service-load-balancer-ip-range ${LB_RANGE} \
--csi-hypervisor-attached-volumes=true \
--ssh-public-key-file ${SSH_KEY_FILE} \
--ssh-username ${SSH_USER} \
--kubernetes-pod-network-cidr ${POD_NET} \
--kubernetes-service-cidr ${SVC_NET} \
--verbose ${VERBOSE} \
--skip-preflight-checks=NutanixCredentials \
--skip-preflight-checks=NutanixPrismCentralVersion \
--airgapped \
--insecure \
--output=yaml \
--self-managed \
--output-directory nx-cluster

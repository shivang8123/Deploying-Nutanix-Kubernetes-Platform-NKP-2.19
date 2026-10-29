# Deploying Nutanix Kubernetes Platform (NKP) 2.19: Hands-On and What's New

![NKP](https://img.shields.io/badge/NKP-2.19-blue) ![Kubernetes](https://img.shields.io/badge/Kubernetes-1.36.2-326CE5) ![Nutanix](https://img.shields.io/badge/Nutanix-NCI%20%7C%20NKP-green)

> Hands-on from deploying a **Nutanix Kubernetes Platform (NKP) 2.19** cluster, plus a summary of what Nutanix officially released in this version.
>
> Author: Shivang Bhardwaj | 6x Nutanix Certified Consultant | NCI | NKP | Cloud Native | Kubernetes | OpenShift | OCI | RHCSA | GCP | DevOps | AHV | HCI | [LinkedIn](https://www.linkedin.com/in/shivang-bhardwaj-7a4516242/)

---

## Table of contents

1. [Overview](#overview)
2. [What's new in NKP 2.19](#whats-new-in-nkp-219)
3. [Compatibility](#compatibility)
4. [Before you install or upgrade](#before-you-install-or-upgrade)
5. [My deployment](#my-deployment)
6. [Validation](#validation)
7. [References](#references)

---

## Overview

NKP 2.19 became generally available in October 2026. Nutanix positions it around a **"dual native"** model: one declarative control plane for Kubernetes clusters running on virtualized infrastructure (AHV) and on bare metal, plus a curated AI catalog for running AI workloads.

This repository documents:

- What changed in 2.19 according to official Nutanix sources
- How I deployed a 2.19 cluster
- What I validated and what I would do differently

---

## What's new in NKP 2.19

### 1. NKP Metal: Kubernetes on bare metal

- Lets you deploy and manage Kubernetes directly on physical servers, using the same operational workflow as virtualized clusters.
- Uses **Foundation Central** for automated node discovery, Ubuntu OS imaging, and cluster provisioning.
- NKP on AHV remains the option for virtualized environments, so you can choose per workload.

### 2. VM Operator for AHV

- A Kubernetes operator, delivered through the NKP App Catalog, that manages supported AHV virtual machine lifecycle operations through Kubernetes APIs.
- Goal: manage VMs and containers with the same workflows.

### 3. AOS multi-writer support (ReadWriteMany)

- Applications can use **ReadWriteMany** file storage served directly from a Nutanix AOS cluster through the Nutanix CSI driver.
- Useful for sharing data across pods, for example CI/CD caches and logs.

### 4. UI-driven upgrade workflows

- Cluster upgrades from the UI, with **pre-flight checks** and **post-upgrade validation** to catch configuration issues and help with maintenance planning.
- The platform applications are now upgraded **before** Kubernetes, cluster infrastructure, and related add-ons.
- For non-ClusterClass clusters, a new `nkp upgrade platform-apps` command upgrades platform applications on their own.

### 5. NKP AI Catalog and AMD GPU support

- A curated catalog of AI and machine-learning tools, deployable from the NKP UI with lifecycle management for supported components.
- Validated support for **AMD Instinct MI350** GPUs and the AMD GPU Operator through the NKP Catalog (subject to documented prerequisites).

### 6. CNCF Kubernetes AI Conformance

- NKP is officially certified under the CNCF Certified Kubernetes AI Conformance Program (starting with 2.18).
- The program validates requirements such as dynamic GPU resource allocation, gang scheduling, and tenant workload isolation.

### 7. Kubernetes version

- Kubernetes **1.36.2** is installed by default.
- The Kubernetes 1.35.x family is also supported.

### 8. AI Navigator improvements

- Dynamic resource discovery, configurable resource exposure, session metrics, and PostgreSQL connection recovery.

> The full, authoritative list is in the official release notes on the Nutanix Portal. This summary is based on the Nutanix blog and community announcement linked in [References](#references).

---

## Compatibility

| Component | Supported in NKP 2.19 |
|---|---|
| Kubernetes | 1.36.2 (default), 1.35.x family |
| Node OS | Rocky Linux 9.8, Red Hat Enterprise Linux 9.8 |
| Bare metal OS (NKP Metal) | Ubuntu (via Foundation Central) |
| GPU | AMD Instinct MI350 with AMD GPU Operator (see prerequisites) |

Always confirm exact versions in the official compatibility matrix before deploying.

---

## Before you install or upgrade

Points Nutanix calls out for administrators:

- **Upgrade the management cluster to 2.19 first**, then the workload clusters.
- Review changes to **Prism Central projects** and **container registry authentication**.
- Check the list of **deprecated components** in the release notes.
- Note the new upgrade order: platform applications first, then Kubernetes and the rest.

---

## My deployment

> Fill in the details below with your own environment. Remove anything that identifies a customer, an internal hostname, an IP address, or a credential.

### Environment

| Item | Value |
|---|---|
| NKP version | v2.19.0 |
| NKP edition | NKP Starter |
| Management cluster | `nkp-mgmt-shivang` |
| Infrastructure provider | Nutanix |
| Kubernetes version | v1.36.2 |
| Prism Central version | pc.7.6 |
| AOS version | 7.6 |
| AHV version | 11.2 |
| Node OS image | Rocky Linux 9.8 |
| Control plane nodes | 1 |
| Worker nodes | 4 |

### Prerequisites checklist

- [x] Prism Central and Prism Element reachable from the bootstrap host
- [x] Node OS image built or available
- [x] Network ranges and VIP reserved for the control plane
- [x] Storage container ready for the Nutanix CSI driver
- [x] Container registry access confirmed
- [x] NKP CLI downloaded for 2.19

---

## Validation

Checks I ran after deployment:

```bash
watch -n 5 "nkp describe cluster --cluster-name nkp-shivang-mgmt" -n kommander
k get ma -A
kubectl get nodes -o wide
k get po -A | egrep -iv "completed|running"
kubectl get pods -A
kubectl get storageclass
kubectl get hr -A
nkp get dashboard
export KUBECONFIG=nkp-mgmt-shivang.conf
```

- [x] NKP UI reachable. The **Administration > Upgrades** page shows the management cluster on **v2.19.0** with Kubernetes **v1.36.2**, status **Newest Version**
- [x] All nodes `Ready`
- [x] All system pods `Running`
- [x] Default StorageClass present and a test PVC binds


---



## References

- Nutanix Blog: [Production AI Meets Dual Native Choice with NKP 2.19](https://www.nutanix.com/blog/production-ai-meets-dual-native-choice-with-nkp)
- Nutanix Community: [Nutanix Kubernetes Platform (NKP) 2.19](https://next.nutanix.com/product-updates/nutanix-kubernetes-platform-nkp-2-19-45966)
- Nutanix Blog: [Introducing NKP Metal](https://www.nutanix.com/blog/introducing-nkp-metal)
- Nutanix press release: [Nutanix Gives Enterprises the Freedom to Run Production Agentic AI Their Way](https://www.globenewswire.com/news-release/2026/08/26/3351400/0/en/nutanix-gives-enterprises-the-freedom-to-run-production-agentic-ai-their-way.html)
- NKP 2.19 release notes and documentation: Nutanix Portal

---

## Disclaimer

This is a personal project and reflects my own experience. It is not an official Nutanix document. Nutanix and related product names are trademarks of Nutanix, Inc. Kubernetes is a registered trademark of The Linux Foundation. Always follow the official documentation for production deployments.

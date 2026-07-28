# 🛡️ RHEL Hybrid Ingress Gateway Automation (PoC)

![Linux](https://img.shields.io/badge/OS-Oracle%20Linux%209%20(RHEL)-red?style=for-the-badge&logo=redhat)
![Nginx](https://img.shields.io/badge/Proxy-Nginx%201.20-green?style=for-the-badge&logo=nginx)
![Docker](https://img.shields.io/badge/Backend-Docker%20Compose-blue?style=for-the-badge&logo=docker)
![Security](https://img.shields.io/badge/Security-SELinux%20Enforcing%20%7C%20Firewalld-orange?style=for-the-badge)
![Ansible](https://img.shields.io/badge/IaC-Ansible%20Automation-black?style=for-the-badge&logo=ansible)

## 📌 Executive Summary
This repository demonstrates an Enterprise-grade **Zero-Trust Edge Ingress Architecture** designed for high-security environments (FinTech / Banking). It solves the critical DevOps challenge of configuring an **Nginx Reverse Proxy** on a hardened **Red Hat Enterprise Linux (RHEL) / Oracle Linux 9** server with **SELinux in Enforcing mode** and strict **Firewalld** network policies.

## 🏗️ Architecture Diagram

```mermaid
graph TD
    Client[🌐 Web Client / Windows Host] -->|HTTP :80 / HTTPS :443| FW[🧱 RHEL Firewalld]

    subgraph RHEL_Server [🖥️ Oracle Linux 9 / RHEL Control Plane]
        FW -->|Allowed Traffic| Nginx[🟢 Nginx Edge Gateway]

        subgraph SELinux_Context [🔒 SELinux Enforcing Boundary]
            Nginx -.->|Blocked by Default| Backend_Mock
            Nginx -->|httpd_can_network_connect = 1| Backend_Mock[📦 Docker Compose API Mock :8080]
        end
    end

    classDef security fill:#f96,stroke:#333,stroke-width:2px;
    class SELinux_Context security;
```

## 🎯 Key Engineering Achievements
* **Zero-Trust Edge Routing:** External clients never access backend databases or microservices directly. All traffic is intercepted, inspected, and routed by the Nginx gateway.
* **SELinux Mastery:** Overcame standard `Permission Denied` proxy blocks by compiling proper SELinux booleans (`setsebool -P httpd_can_network_connect 1`) without disabling system security (`setenforce 0` is strictly prohibited).
* **Network Hardening:** Configured `firewalld` to strictly expose only Web Edge ports (`80/443`), dropping all unauthorized external packets.
* **Containerized Core Backend:** Implemented a lightweight Python API mock running as a **non-root user** inside an isolated Docker Compose network.
* **Infrastructure as Code (IaC):** Fully codified setup using modular Ansible Playbooks to guarantee idempotency and rapid disaster recovery.

## 🗂️ Repository Hierarchy
```text
rhel-edge-ingress-automation/
├── .github/workflows/          # CI/CD pipelines for linting and security scans
├── ansible/                    # IaC: Automated server provisioning
│   ├── inventory/              # Target server environments
│   ├── roles/                  # Modular roles: OS, Firewalld, Nginx, SELinux
│   └── setup-edge.yml          # Master playbook
├── docker/
│   └── backend/                # Mock FinTech Core API (Python + Docker Compose)
│       ├── Dockerfile          # Non-root container build
│       ├── api.py              # Mock JSON status endpoint
│       └── docker-compose.yml  # Backend orchestration
├── nginx/
│   └── conf.d/                 # Standardized Nginx reverse proxy routing
└── README.md
```

## 🚀 Quick Start & Verification
*(Detailed execution instructions and automated CI/CD deployment logs will be added in upcoming releases).*
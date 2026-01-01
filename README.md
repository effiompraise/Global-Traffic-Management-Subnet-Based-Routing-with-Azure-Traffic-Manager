# Global Traffic Management: Subnet-Based Routing with Azure Traffic Manager

![Traffic Manager Banner](/images/traffic_manager_banner.png)

## Introduction

In this project, I engineered a global traffic routing solution using **Azure Traffic Manager**. The objective was to demonstrate **Subnet-Based Traffic Routing**, a method that directs user traffic to specific endpoints based on the IP address range (subnet) of the incoming request.

This architecture is critical for compliance (data residency), optimizing latency for internal corporate networks, and geofencing content. By leveraging Traffic Manager's DNS-based load balancing, I ensured high availability and granular control over how different user segments accessed the application.

## Objectives

-   **Deploy Multi-Region Infrastructure:** Provision Azure Virtual Machines in distinct regions (East US and West Europe) to act as regional endpoints.
-   **Configure Web Services:** Install and configure IIS on both VMs to serve region-specific content for verification.
-   **Implement Traffic Manager:** Create a Traffic Manager profile with the **Subnet** routing method.
-   **Define Traffic Ranges:** Map specific CIDR IP ranges to specific endpoints to enforce routing rules.
-   **Verify DNS Routing:** validate that requests from specific subnets are correctly routed to their assigned regional endpoint.

## Tech Stack

![Traffic Manager](https://img.shields.io/badge/Azure_Traffic_Manager-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Virtual Machines](https://img.shields.io/badge/Azure_VMs-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![IIS](https://img.shields.io/badge/IIS_Web_Server-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![DNS](https://img.shields.io/badge/DNS_Routing-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)

-   **Azure Traffic Manager:** DNS-based traffic load balancer.
-   **Azure Virtual Machines:** Compute resources hosting the web application.
-   **PowerShell:** Used for rapid configuration and testing.
-   **DNS:** CNAME and Public IP label configuration.

## Architecture

![Traffic Manager Diagram](/images/traffic_manager_diagram.png)

The solution uses a **DNS-level routing** approach:
1.  **User Request:** A user attempts to resolve the domain name (e.g., `whizlabstm.trafficmanager.net`).
2.  **IP Analysis:** Traffic Manager analyzes the source IP address of the DNS query.
3.  **Routing Table Lookup:** It checks the configured Subnet maps.
    * *If IP is in Range A* $\rightarrow$ Return IP of **East US VM**.
    * *If IP is in Range B* $\rightarrow$ Return IP of **West Europe VM**.
4.  **Connection:** The user connects directly to the assigned regional VM.

## Implementation Steps

### Phase 1: Infrastructure Deployment

I provisioned two Windows Server 2019 Data Center Virtual Machines in separate regions to simulate a global footprint.
* **VM 1:** `myWhizVM1` (East US)
* **VM 2:** `myWhizVM2` (West Europe)

![VM Creation](/images/vm_creation.png)
*Figure 1: Deploying the regional Virtual Machines.*

### Phase 2: Web Server Configuration (IIS)

To visualize the routing, I installed IIS on both VMs and customized the default home page to display the VM's name. This allows for immediate visual verification of which endpoint served the request.

![IIS Configuration](/images/iis_config.png)
*Figure 2: Configuring IIS and the default HTML page.*

### Phase 3: DNS Configuration

Traffic Manager works via DNS, so each VM required a public DNS label.
* **myWhizVM1:** `mywhizvm1-dns.eastus.cloudapp.azure.com`
* **myWhizVM2:** `mywhizvm2-dns.westeurope.cloudapp.azure.com`

![DNS Setup](/images/dns_setup.png)
![DNS Setup](/images/dns_setup1.png)
*Figure 3: Assigning public DNS labels to the Virtual Machine public IPs.*

### Phase 4: Traffic Manager Profile

I created a Traffic Manager profile with the **Subnet** routing method. This method specifically allows us to map IP ranges to endpoints.

* **Routing Method:** Subnet
* **Resource Group:** `TrafficManager-RG`

![Traffic Manager Creation](/images/tm_create.png)
*Figure 4: Creating the Traffic Manager profile with Subnet routing.*

### Phase 5: Endpoint Configuration

I added the two VMs as endpoints to the profile and defined the subnet ranges.
* **Endpoint 1 (East US):** Mapped to subnet `1.2.3.4/24` (Example/Test range).
* **Endpoint 2 (West Europe):** Mapped to subnet `5.6.7.8/24`.

![Endpoint Setup](/images/endpoint_setup.png)
*Figure 5: Adding the regional VMs as endpoints and defining IP ranges.*

### Phase 6: Verification

To verify the solution, I connected to the VMs via RDP. Since `myWhizVM1` falls within the IP range assigned to the East US endpoint (itself), browsing to the Traffic Manager URL `http://mywhiztm.trafficmanager.net` correctly routed the request back to `myWhizVM1`.

![Verification](/images/verification.png)
*Figure 6: Verifying that the Traffic Manager URL resolves to the correct regional endpoint.*

## Key Results

* **Granular Traffic Control:** Successfully implemented routing logic that discriminates based on client IP subnets.
* **High Availability:** Verified that Traffic Manager acts as a global entry point; if one endpoint definition changes, the DNS update propagates automatically.
* **Latency Optimization:** Demonstrated how users can be forced to the physically closest data center to ensure the lowest possible latency.

---

## Repository Contents

* `/images` - Screenshots of the configuration process.
* `/scripts` - PowerShell snippets used for IIS installation.

## About This Project

**Role:**
Cloud Network Engineer

**Skills Demonstrated:**
Azure Traffic Manager, DNS Routing, Azure Networking, Load Balancing, IIS Configuration.
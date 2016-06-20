#NEI Pilot Project - Web Application

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FExchMaster%2FNEI-Pilot-Projects%2Fmaster%2Fazuredeploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a>

This template deploys a 3 tier topology for hosting a web application.  Each tier consists of a set of virtual machines running CentOS 7.2, a load balancer, and a subnet.  Please note, when deploying this template it is advisable to deploy into a resource group that is different from the virtual network which will host the infrastructure.  This will allow you to delete the resources without affecting the underlying network.

##Overview of Tiers

* __Proxy__:  This tier hosts the public facing load balancer and the proxy virtual machines.  Incoming TCP port 80 & 443 are load balanced between the proxy systems with health checking occurring at the TCP level.  SSL termination and traffic inspection will occur at this tier and assuming that the traffic passes all hygiene tests, will be forwarded to the Web tier load balancer for further processing.
* __Web__:  This tier hosts an internal load balancer which receives approved traffic from the Proxy tier.  The Web tier load balancer load balances port 80 and 443 across the Web virtual machines in this tier.  
* __Dbase__:  This tier hosts an internal load balancer which receives traffic from the Web tier.  The Dbase tier load balancer load balances port 3306 (the default TCP port for MariaDB/MySQL) across the Dbase virtual machines hosting the databases required to support the Web tier.

##Pre-requisites for Deployment

Prior to attempting to deploy this template, please open the virtual network object where you will deploy the template and gather the following:

*Virtual Network Name
*Virtual Network Resource Group
*Virtual Network Subnet Names (Map a subnet name to each tier: proxy, web, dbase)

For the subnets which will host the Web and Dbase tiers, please pick an unused IP address from each subnet range.  These two IP addresses will be used for the internal load balances on each respective tier (see below for more details).

##Deployment Parameters

To deploy this template, please click "Deploy to Azure" shown above.  Once you click to deploy, you will be presented with a list of parameters which must be filled out properly to ensure the solution can deploy successfully.  Shown below are the parameters and the information needed to fill each out successfully.

1. __RESOURCENAMEPREFIX__: This is the prefix used to assign names to all resources which are deployed.  For example, if you type in "jai12345", then the virtual machines created in each tier will have a name of: "jai12345vm-proxy", "jai12345vm-web", "jai12345vm-proxy".  Only use letters and numbers for this field, using other character types (a dash for example) will result in a failed deployment. 
2. __ADMINUSERNAME__: This will be the name of the local system root user.  The value for this field cannot be 'root', 'admin', or 'administrator'.
3. __ADMINPASSWORD__: This will be the default password of the local system root user.  Must be 12 characters in length, use upper and lower case characters, and at least one special character.  Most passwords derived from the word 'password' are blocked automatically and will cause the deployment to fail.
4. __DEPLOYMENTVNET__: The pre-existing virtual network where all virtual machines will be deployed.  For example, if you already have a VNET where you would like to deploy this infrastructure which is already configured and has VPN connectivity, simply put the name of the VNET in this field.
5. __DEPLOYMENTVNETRESOURCEGROUP__: The pre-existing resource group name that contains the virtual network defined by 'deploymentVNET'.  The deployment VNET has already been deployed and is currently a part of an existing resource group.  The name of that resource group should be put into this field.
6. __DEPLOYMENTPROXYSUBNET__: The pre-existing subnet name within the virtual network defined by 'deploymentVNET' which will contain the proxy tier of this web application.  This template will deploy successfully whether you use different subnets for each tier, or if you use the same subnet for all tiers.
7. __DEPLOYMENTWEBSUBNET__:  The pre-existing subnet name within the virtual network defined by 'deploymentVNET' which will contain the web tier of this web application.  This template will deploy successfully whether you use different subnets for each tier, or if you use the same subnet for all tiers.
8. __DEPLOYMENTDBASESUBNET__: The pre-existing subnet name within the virtual network defined by 'deploymentVNET' which will contain the dbase tier of this web application.  This template will deploy successfully whether you use different subnets for each tier, or if you use the same subnet for all tiers.
9. __WEBLBPRIVATEIPADDRESS__:  This is the private IP address of the load balancer deployed in the web tier.  The IP address assigned here must be a valid IP address within the subnet identified within 'deploymentWebSubnet'.
10. __DBASELBPRIVATEIPADDRESS__:  This is the private IP address of the load balancer deployed in the database tier.  The IP address assigned here must be a valid IP address within the subnet identified within 'deploymentDBaseSubnet'.
11. __PROXYVMSIZE__:  The default value deploys a Standard_A6 VM utilizing 4 x CPU cores and 28 GB of RAM.  The full list of virtual machine sizes is available at the following link: [https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-sizes/](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-sizes/)
12. __PROXYVMCOUNT__:  This represents the number of virtual machines to deploy within the Proxy tier.  The virtual machines deployed will be of the size defined by 'proxyVMSize'.
11. __WEBVMSIZE__:  The default value deploys a Standard_A6 VM utilizing 4 x CPU cores and 28 GB of RAM.  The full list of virtual machine sizes is available at the following link: [https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-sizes/](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-sizes/)
12. __WEBVMCOUNT__:  This represents the number of virtual machines to deploy within the Web tier.  The virtual machines deployed will be of the size defined by 'webVMSize'.
11. __DBASEVMSIZE__:  The default value deploys a Standard_A6 VM utilizing 4 x CPU cores and 28 GB of RAM.  The full list of virtual machine sizes is available at the following link: [https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-sizes/](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-sizes/)
12. __DBASEVMCOUNT__:  This represents the number of virtual machines to deploy within the Dbase tier.  The virtual machines deployed will be of the size defined by 'dbaseVMSize'.


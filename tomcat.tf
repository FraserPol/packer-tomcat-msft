{
  "variables": {
    "azure_client_id": "{{ env `ARM_CLIENT_ID` }}",
    "azure_client_secret": "{{ env `ARM_CLIENT_SECRET` }}",
    "azure_subscription_id": "{{ env `ARM_SUBSCRIPTION_ID` }}",
    "azure_resource_group": "{{ env `AZURE_RESOURCE_GROUP` }}",
    "azure_location": "{{ env `AZURE_LOCATION` }}",
    "environment": "{{ env `PACKER_ENVIRONMENT` }}",
    "vcs_name": "{{ env `VCS_NAME` }}",
    "consul_version": "{{ env `CONSUL_VERSION` }}",
    "consul_ent_url": "{{ env `CONSUL_ENT_URL` }}",
    "distribution": "{{ env `DISTRIBUTION` }}"
  },
    "builders": [
  {
      "name": "azure-managed-image-RHEL-7.3-systemd",
      "type": "azure-arm",
      "client_id": "{{ user `azure_client_id` }}",
      "client_secret": "{{ user `azure_client_secret` }}",
      "subscription_id": "{{ user `azure_subscription_id` }}",
      "managed_image_resource_group_name": "{{ user `azure_resource_group` }}",
      "location": "{{ user `azure_location` }}",
      "image_publisher": "RedHat",
      "image_offer": "RHEL",
      "image_sku": "7.3",
      "os_type": "Linux",
      "ssh_username": "packer",
      "managed_image_name": "fp-RHEL-{{timestamp}}",
      "azure_tags": {
          "Name": "HashiStack Server",
          "System": "HashiStack",
          "Product": "HashiStack",
          "Environment": "{{ user `environment` }}",
          "Built-By": "{{ user `vcs_name` }}",
          "OS": "RHEL",
          "OS-Version": "7.3",
          "Consul-Version": "{{ user `consul_version` }}"
      }
  }
],
  "provisioners": [

    {
        "type": "shell",
        "inline": [
          "sleep 30",
          "yum makecache fast",
          "sudo yum -y update"
        ]
    },



    {
        "execute_command": "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'",
        "inline": [
            "apt-get update -qq -y",
            "apt-get upgrade -qq -y",

            "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"
        ],
        "inline_shebang": "/bin/sh -x",
        "type": "shell"
    }
  ]
}

---
layout: post
title: Testing Ansible Provisioning Locally
tags: programming infrastructure testing
excerpt: Learn how to test Ansible provisioning scripts locally
summary: Learn how to test Ansible provisioning scripts locally
image: /assets/img/uploads/ansible-local-testing-title.png
comments: true
---

Whenever I need to provision servers I reach for bash scripts or use [Ansible](https://www.ansible.com/) to do the tedious work of installing packages and configuring services for me. In contrast to other provisioning tools both Ansible and bash have no built-in way to test that the scripts you're writing actually do what you want them to do. Spinning up a real server in order to test your scripts, can either become expensive or simply annoying. Time to fix that.

With the help two little tools, we can make local testing of provisioning scripts faster and more pleasant. It's my go to way these days - there might be more sophisticated approaches out there but this is what works well for me (I'm not doing any rocket science anyways).

We're going to use [Vagrant](https://www.vagrantup.com/) to spin up a local VM, provision that VM with Ansible and then use [Serverspec](https://serverspec.org/) to verify that everything worked as intended.

## Example Code Repository
You can find a simple example of everything I describe here in my [example repository on GitHub](https://github.com/hamvocke/ansible-local-testing-sample). Check it out, fork it and use it as a foundation for your next project.

## Vagrant Setup
After you've [installed Vagrant](https://www.vagrantup.com/docs/installation/) on your machine you're ready to spin up a virtual machine on your local computer.

A `Vagrantfile` in our project root will configure Vagrant. With this file you declare the operating system image Vagrant should use for the VM. You can also configure networking and provide additional steps to provision the VM.

The following `Vagrantfile` will make Vagrant spin up an Ubuntu machine and run Ansible during Vagrant's provisioning step. Ansible will run on the VM, not on the host, as we're using `ansible_local`, not `ansible` as our provisioner. After running Ansible, Vagrant will then use Serverspec to run our tests.

```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.provision "ansible_local" do |ansible|
    ansible.limit = 'all'
    ansible.inventory_path = 'hosts'
    ansible.playbook = 'local.yml'
  end

  config.vm.provision :serverspec do |spec|
    spec.pattern = 'test/*_spec.rb' # pattern for test files
  end
```

Before we can use this configuration, we need to install the [vagrant-serverspec](https://github.com/vvchik/vagrant-serverspec) plugin:

```
$ vagrant plugin install vagrant-serverspec
```

## Ansible Configuration
I like to use Ansible playbooks and roles, even if what I'm doing is quite small. In the example repository I've added a simple role that installs nginx on our virtual machine. This can be a good starting point for you to go crazy and add more steps to your roles, more roles and do whatever you have to do in order to provision your server.

### Inventory
Ansible uses a so-called _inventory_ to find out which hosts to provision. For testing, we declare localhost (the _[local]_ block). We also declare all our other remote servers that we want to provision in this file (similar to the _[some-other-server_ block).

```
[local]
127.0.0.1 ansible_python_interpreter=/usr/bin/python3

[some-other-server]
<some_remote_ip> ansible_python_interpreter=/usr/bin/python3
```

### Playbook
Playbooks are a way to tell Ansible what roles to apply to which hosts and how to connect to these hosts. For our local testing, we have a special playbook called `local.yml`. In our Vagrantfile we tell the Ansible provisioner to use this file as the playbook that should be executed for provisioning the VM.

```yml
- hosts: local
  connection: local
  become: yes
  become_user: root
  roles:
    - nginx
```

As we've configured `ansible_local` as the provisioner for Vagrant, we tell our playbook to use a local connection to the host declared with the name _local_  in the Inventory (the `hosts` file). Remember, Ansible is executed on the VM directly, not on the host, that's why we use a _local_ connection instead of _ssh_ here. Also, we define that our playbook should execute the _nginx_ role only.

Besides the `local.yml` playbook, we can have multiple other playbooks that we can then use to tell Ansible how to provision our real servers and what roles to apply. I've added an example for remote server provisioning in the example repository.

## Serverspec Tests
Vagrant and Ansible are set up and we have a simple Ansible role in place. It's time to look at our Serverspec tests in the `test` directory.

Change the tests according to your needs and provisioning steps. Make sure that all your test files end with the `_spec.rb` pattern so that our Vagrant provisioner can find them.

This is what a simple test will look like:

```ruby
require_relative 'spec_helper'

describe service('nginx') do
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end
```

The [Serverspec documentation](https://serverspec.org/resource_types.html) gives you an overview over a lot of helpful resource types you can use for your tests.

## Workflow
With this in place, you can go ahead, write your Ansible roles and test them properly with Serverspec.

To test your provisioning scripts locally, simply use `vagrant up` or `vagrant provision` to spin up and provision your Vagrant VM. After a short while you'll see the output of both, Ansible and Serverspec in your terminal and you'll know if everything worked as intended or if there's a problem with your ansible scripts:

```
PLAY [local] *******************************************************************
TASK [Gathering Facts] *********************************************************
ok: [127.0.0.1]
TASK [nginx : Install packages] ************************************************
changed: [127.0.0.1] => (item=[u'nginx'])
TASK [nginx : Restart nginx] ***************************************************
changed: [127.0.0.1]
PLAY RECAP *********************************************************************
127.0.0.1                  : ok=3    changed=2    unreachable=0    failed=0
==> default: Running provisioner: serverspec...
..
Finished in 0.53478 seconds (files took 0.08154 seconds to load)
2 examples, 0 failures
```

Once you're sure that your provisioning scripts work correctly, you can provision your remote servers by calling Ansible with a different playbook:

```
ansible-playbook remote.yml -u root -i hosts
```

That's all there is. Go ahead, provision and test all you can!

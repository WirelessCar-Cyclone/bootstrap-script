
empty:=
ws:=$(empty) $(empty)

all: aks-uri publish

.SILENT: az-login
.PHONY: az-login
az-login:
	az login --service-principal -u $(SERVICE_PRINCIPAL_ID) -p $(SERVICE_PRINCIPAL_PASSWD) --tenant $(SERVICE_PRINCIPAL_TENANT)

git-clone: setup-git
	./clone.sh

ENVS := prod-westeurope prod-northeurope nonprod-francecentral infra-uksouth
.PHONY: $(ENVS)
aks-uri: $(ENVS)
$(ENVS): git-clone az-login
	$(eval URI := $(shell az aks show -n $@-aks -g $@-rg --query fqdn))
	yq w -i out/target/$(word 1,$(subst -,$(ws),$@))-aks/bootstrap/values.yaml  global.destination.$(subst -,_,$@) https://$(URI):443

####### Download and setup ssh key for git access #######

/root/.ssh/devops-azure-repos-key-rsa: az-login
	mkdir -p $(dir $@)
	rm -rf $@
	az keyvault secret download --file $@ --encoding base64 --vault-name CycloneKeyVault --name $(notdir $@)

.PHONY: setup-git
setup-git: /root/.ssh/devops-azure-repos-key-rsa
	./setupgit.sh $(notdir $<)

####### Handle version increment #######

.PHONY: major minor patch version

version:
	@if ! test -f version; then mkdir -p version; fi
	@if ! test -f version/major; then echo 0 > version/major; fi
	@if ! test -f version/minor; then echo 0 > version/minor; fi
	@if ! test -f version/patch; then echo 0 > version/patch; fi

major minor patch: version
	@echo $$(($$(cat version/$@) + 1)) > version/$@

####### Tag and upload to git #######

.PHONY: publish

publish: setup-git patch
	./publish.sh

####### Compile and print a list of available targets #######

.PHONY: list

list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

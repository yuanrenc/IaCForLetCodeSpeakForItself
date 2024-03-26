ENV ?= "dev"
DEPLOY_VERSION ?= "latest"
STATE_BUCKET = "bucket=let-code-speak-for-itself.ap-southeast-2.terraform"

init-%:
	@COMMAND="-chdir=/workdir/$* init -backend-config='$(STATE_BUCKET)'" \
	docker-compose run tf-action
	-@COMMAND="-chdir=/workdir/$* workspace new $(ENV)" \
	docker-compose run tf-action
	@COMMAND="-chdir=/workdir/$* workspace select $(ENV)" \
	docker-compose run tf-action

init-state:
	@COMMAND="-chdir=/workdir/state init" \
	docker-compose run tf-action

lint-%: init-%
	@COMMAND="-chdir=/workdir/$* fmt \
		-write=false \
		-diff=true \
		-check=true" \
	docker-compose run tf-action
	@COMMAND="-chdir=/workdir/$* validate" \
	docker-compose run tf-action

plan-%: init-%
	@COMMAND="-chdir=/workdir/$* plan \
		-input=false \
		-compact-warnings \
		-out=/workdir/$*/$*-tfplan \
		-var env=$(ENV) \
		-var-file=/workdir/env/$(ENV).tfvars" \
	docker-compose run tf-action

plan-application: init-application
	@COMMAND="-chdir=/workdir/application plan \
		-input=false \
		-compact-warnings \
		-out=/workdir/application/application-tfplan \
		-var env=$(ENV) \
		-var deploy_version=$(DEPLOY_VERSION) \
		-var-file=/workdir/env/$(ENV).tfvars" \
	docker-compose run tf-action

apply-%: init-%
	@COMMAND="-chdir=/workdir/$* apply $*-tfplan" \
	docker-compose run tf-action

destroy-%: init-%
	@COMMAND="-chdir=/workdir/$* destroy \
		-auto-approve \
		-input=false \
		-var env=$(ENV) \
		-var-file=/workdir/env/$(ENV).tfvars" \
	docker-compose run tf-action
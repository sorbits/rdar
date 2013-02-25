#include <dispatch/dispatch.h>
#include <Block.h>
#include <stdio.h>
#include <stdlib.h>
#include <memory>

void setup_dispatch ()
{
	struct record_t
	{
		record_t ()  { fprintf(stderr, "%p: create\n", this); }
		~record_t () { fprintf(stderr, "%p: dispose\n", this); }
	};

	std::shared_ptr<record_t> record(new record_t);

	dispatch_group_t group = dispatch_group_create();

	dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
		fprintf(stderr, "%p: invoke\n", record.get());
	});

	dispatch_group_notify(group, dispatch_get_main_queue(), ^{
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC >> 3), dispatch_get_main_queue(), ^{
			exit(0);
		});
	});

	dispatch_release(group);
}

int main (int argc, char const* argv[])
{
	setup_dispatch();
	dispatch_main();
	return 0;
}

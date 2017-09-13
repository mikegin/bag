note
	description: "es-template application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT

inherit
	ES_SUITE

create
	make

feature {NONE} -- Initialization
	adt_bag: detachable ADT_BAG[STRING]
	make
			-- Run application.
		do
			add_test (create {INSTRUCTOR_TEST1}.make)
			add_test (create {STUDENT_TESTS}.make)
			show_browser
			show_errors
			run_espec
		end

end

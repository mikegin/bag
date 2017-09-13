note
	description: "Summary description for {STUDENT_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TESTS

inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t3)
			add_boolean_case (agent t4)
			add_boolean_case (agent t5)
			add_boolean_case (agent t6)
			add_boolean_case (agent t7)
			add_boolean_case (agent t8)
			add_boolean_case (agent t9)
			add_boolean_case (agent t10)
			add_boolean_case (agent t11)
		end

feature -- tests

	t1: BOOLEAN
		local
			bag: MY_BAG[STRING]
			a: ARRAY[STRING]
		do
			comment("t1: test domain")

			create bag.make_empty

			bag.extend ("nuts", 5)
			bag.extend ("bolts", 2)
			bag.extend ("apples", 3)
			bag.extend ("geese", 1)

			a := bag.domain

			Result := a[1] ~ "apples" and a[2] ~ "bolts" and a[3] ~ "geese" and a[4] ~ "nuts"
		end

	t2: BOOLEAN
		local
			bag: MY_BAG[STRING]
		do
			comment("t2: test occurences")

			create bag.make_empty

			bag.extend ("nuts", 5)
			bag.extend ("bolts", 2)
			bag.extend ("apples", 3)
			bag.extend ("geese", 1)

			Result := bag.occurrences ("nuts") = 5 and bag.occurrences ("bolts") = 2 and bag.occurrences ("apples") = 3 and bag.occurrences ("geese") = 1 and bag.occurrences ("doesn't exist") = 0
		end

	t3: BOOLEAN
		local
			bag: MY_BAG[STRING]
		do
			comment("t3: test extend")

			create bag.make_empty

			bag.extend ("nuts", 5)
			bag.extend ("nuts", 2)
			bag.extend ("bolts", 2)
			bag.extend ("bolts", 0)

			Result := bag.occurrences ("nuts") = 7 and bag.occurrences ("bolts") = 2
		end

	t4: BOOLEAN
		local
			bag: MY_BAG[STRING]
		do
			comment("t4: test bag iterator")

			create bag.make_empty

			Result := across bag as it all bag[it.item] > 0 end -- check that this doesn't crash when no items in the bag

			bag.extend ("nuts", 5)
			bag.extend ("nuts", 2)
			bag.extend ("bolts", 2)
			bag.extend ("bolts", 0)

			Result := across bag as it all bag[it.item] > 0 end
		end

	t5: BOOLEAN
		local
			a: ARRAY [TUPLE [x: STRING; y: INTEGER]]
			bag: MY_BAG[STRING]
		do
			comment("t5: test make from tuple array")

			create a.make_empty
			a.force (["nuts", 5], a.upper + 1)
			a.force (["nuts", 2], a.upper + 1)
			a.force (["bolts", 2], a.upper + 1)
			a.force (["bolts", 0], a.upper + 1)
			a.force (["apples", 3], a.upper + 1)
			a.force (["geese", 1], a.upper + 1)

			create bag.make_from_tupled_array (a)

			Result := bag.occurrences ("nuts") = 7 and bag.occurrences ("bolts") = 2 and bag.occurrences ("apples") = 3 and bag.occurrences ("geese") = 1 and bag.occurrences ("doesn't exist") = 0
		end

	t6: BOOLEAN
		local
			bag1: MY_BAG[STRING]
			bag2: MY_BAG[STRING]
			bag3: MY_BAG[STRING]
		do
			comment("t6: test subset")

			create bag1.make_empty
			create bag2.make_empty
			create bag3.make_empty

			bag1.extend ("nuts", 5)
			bag1.extend ("nuts", 2)
			bag1.extend ("bolts", 2)
			bag1.extend ("bolts", 0)

			bag2.extend ("nuts", 8)
			bag2.extend ("bolts", 2)
			bag2.extend ("hammer", 1)

			bag3.extend ("nuts", 9)

			Result := bag2 |<: bag3
			check not Result end

			Result := bag3 |<: bag2
			check not Result end

			Result := bag1 |<: bag2

		end

	t7: BOOLEAN
		local
			bag1: MY_BAG[STRING]
			bag2: MY_BAG[STRING]
			bag3: MY_BAG[STRING]
		do
			comment("t7: test bag_equal")

			create bag1.make_empty
			create bag2.make_empty
			create bag3.make_empty

			bag1.extend ("nuts", 7)
			bag1.extend ("bolts", 2)
			bag1.extend ("hammer", 1)

			bag2.extend ("nuts", 8)
			bag2.extend ("bolts", 2)
			bag2.extend ("hammer", 1)

			bag3.extend ("nuts", 8)
			bag3.extend ("bolts", 2)
			bag3.extend ("hammer", 1)

			Result := bag1.bag_equal (bag2)
			check not Result end

			Result := bag2.bag_equal (bag1)
			check not Result end

			Result := bag2.bag_equal (bag3)

		end

	t8: BOOLEAN
		local
			bag1: MY_BAG[STRING]
			bag2: MY_BAG[STRING]
		do
			comment("t8: test add_all")

			create bag1.make_empty
			create bag2.make_empty

			bag1.extend ("nuts", 7)
			bag1.extend ("bolts", 2)
			bag1.extend ("hammer", 1)

			bag2.extend ("nuts", 8)
			bag2.extend ("bolts", 2)
			bag2.extend ("hammer", 1)
			bag2.extend ("apples", 4)
			bag2.extend ("geese", 2)

			bag1.add_all (bag2)

			Result := bag1.occurrences ("nuts") = 15 and bag1.occurrences ("bolts") = 4 and bag1.occurrences ("hammer") = 2 and bag1.occurrences ("apples") = 4 and bag1.occurrences ("geese") = 2

		end

	t9: BOOLEAN
		local
			bag: MY_BAG[STRING]
		do
			comment("t9: test remove")

			create bag.make_empty

			bag.extend ("nuts", 7)
			bag.extend ("bolts", 2)
			bag.extend ("hammer", 1)

			bag.remove ("nuts", 5)
			bag.remove ("bolts", 3)
			bag.remove ("geese", 3)

			Result := bag.occurrences ("nuts") = 2 and bag["bolts"] = 0 and bag["hammer"] = 1

		end

	t10: BOOLEAN
		local
			bag1: MY_BAG[STRING]
			bag2: MY_BAG[STRING]
		do
			comment("t10: test remove_all")

			create bag1.make_empty
			create bag2.make_empty

			bag1.extend ("nuts", 7)
			bag1.extend ("bolts", 2)
			bag1.extend ("hammer", 1)

			bag2.extend ("nuts", 8)
			bag2.extend ("bolts", 2)
			bag2.extend ("hammer", 1)
			bag2.extend ("apples", 4)
			bag2.extend ("geese", 2)

			bag2.remove_all (bag1)

			Result := bag2.occurrences ("nuts") = 1 and bag2.occurrences ("bolts") = 0 and bag2.occurrences ("hammer") = 0 and bag2.occurrences ("apples") = 4 and bag2.occurrences ("geese") = 2
			check Result end

			bag2.remove_all (bag2)

			Result := across bag2 as it all bag2[it.item] = 0 end -- bag2 is empty

		end

	t11: BOOLEAN
		local
			bag: MY_BAG[STRING]
		do
			comment("t11: can change the bag while iterating?")

			create bag.make_empty

			bag.extend ("nuts", 8)
			bag.extend ("bolts", 2)
			bag.extend ("hammer", 1)
			bag.extend ("apples", 4)
			bag.extend ("geese", 2)

			across bag as it loop bag.remove (it.item, bag[it.item]) end -- should not mess up

			Result := True

		end



end

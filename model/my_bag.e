note
	description: "Summary description for {MY_BAG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_BAG[G -> {HASHABLE, COMPARABLE}]

inherit
	ADT_BAG[G]
		redefine out end

	DEBUG_OUTPUT
		undefine out end

create
	make_empty, make_from_tupled_array

convert
	make_from_tupled_array ({attached ARRAY [attached TUPLE [x: G; y: INTEGER]]})

feature -- creation
	make_empty
		do
			create table.make (10)
		end

	make_from_tupled_array (a_array: ARRAY [TUPLE [x: G; y: INTEGER]])
		local
			i: INTEGER
			curtup: TUPLE [x: G; y: INTEGER]
		do
			create table.make (10)

			from
				i := a_array.lower
			until
				i > a_array.upper
			loop
				curtup := a_array[i]
				extend (curtup.x, curtup.y)

				i := i + 1
			end
		end

feature{NONE} -- Attributes
	table: HASH_TABLE[INTEGER, G]

feature -- creation queries

	is_nonnegative(a_array: ARRAY [TUPLE [x: G; y: INTEGER]]): BOOLEAN
			-- Are all the `y' fields of tuples in `a_array' non-negative
		do
			Result := (across a_array as it all it.item.y >=0 end)
		end

feature -- bag equality
	bag_equal alias "|=|"(other: like Current): BOOLEAN
			-- equal to current object?
		do
			Result := Current |<: other and other |<: Current
		end

feature -- queries

	count: INTEGER
			-- cardinality of the domain
		do
			Result := domain.count
		end


	domain: ARRAY[G]
			-- sorted domain of bag
		local
			a: SORTED_TWO_WAY_LIST[G]
   		do
   			create Result.make_empty
   			Result.compare_objects

   			create a.make

   			across
   				table as t
   			loop
   				if t.item > 0 then -- to satisfy postcondition
   					a.extend (t.key)
   				end
   			end

   			across
   				a as list
   			loop
   				Result.force(list.item, Result.upper + 1)
   			end

   		end

 	occurrences alias "[]" (key: G): INTEGER
			-- Anything out of the domain can simply be considered out of the bag,
			-- i.e. has a number of occurrences of 0.
		do
			across
				table as t
			loop
				if t.key ~ key then
					Result := t.item
				end
			end
		end

	is_subset_of alias "|<:" (other: like Current): BOOLEAN
			-- current bag is subset of `other'
			-- <=
		do
			Result := across domain as g all
						has(g.item) implies other.has(g.item) and then
						occurrences(g.item) <= other.occurrences(g.item)
				end
		end

	out: STRING
		do
			Result := debug_output
		end

	debug_output: STRING
		do
			create Result.make_empty
			Result.append ("{")

			across
				domain as d
			loop
				if attached {ANY} d.item as i then
					Result.append ("[" + i.out + "," + occurrences (d.item).out + "], ")
				end
			end
			Result.append ("}")
		end

feature{MY_BAG_ITERATION_CURSOR} -- cursor used domain

	domain_with_zeroes: ARRAY[G]
			-- sorted domain with zeroes of bag
		local
			a: SORTED_TWO_WAY_LIST[G]
   		do
   			create Result.make_empty
   			Result.compare_objects

   			create a.make

   			across
   				table as t
   			loop
   				a.extend (t.key)
   			end

   			across
   				a as list
   			loop
   				Result.force(list.item, Result.upper + 1)
   			end

   		end

feature -- commands
	extend  (a_key: G; a_quantity: INTEGER)
			-- add [a_key, a_quantity] to the bag
			-- add additional quantities if item already is in the bag
		do
			if table.has (a_key) then
				table.replace (table.item (a_key) + a_quantity, a_key)
			else
				table.extend (a_quantity, a_key)
			end
		end

	add_all (other: like Current)
			-- add all elements in the bag `other'
		do
			across
				other.domain as it
			loop
				extend(it.item, other[it.item])
			end
		end

	remove  (a_key: G; a_quantity: INTEGER)
			-- remove [a_key, a_quantity] from the bag
		do
			if has(a_key) then
				table.replace ((occurrences(a_key) - a_quantity).max(0), a_key) -- sets to zero instead of removing from the hashtable for iteration purposes
			end
		end

	remove_all (other: like Current)
		  -- bag difference
		  -- i.e. no. of items in Current
		  -- minus no. of times in other,
		  -- or zero
		do
			across
				other.domain as it
			loop
				remove(it.item, other[it.item])
			end
		end

feature -- Access

	new_cursor: MY_BAG_ITERATION_CURSOR [G]
			-- Fresh cursor associated with current structure
		do
			create Result.make (Current)
		end

end

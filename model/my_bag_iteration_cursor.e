note
	description: "Summary description for {MY_BAG_ITERATION_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_BAG_ITERATION_CURSOR[G -> {HASHABLE, COMPARABLE}]

inherit
	ITERATION_CURSOR[G]

create
	make

feature -- Initialization
	make(a_bag: like bag)
		do
			bag := a_bag
			index := bag.domain_with_zeroes.lower
		end

feature -- Attributes
	bag: MY_BAG[G]
	index: INTEGER

feature -- Access

	item: G
			-- Item at current cursor position.
		do
			Result := bag.domain_with_zeroes[index]
		end

feature -- Status report	

	after: BOOLEAN
			-- Are there no more items to iterate over?
		do
			Result := index > bag.domain_with_zeroes.upper
		end

feature -- Cursor movement

	forth
			-- Move to next position.
		do
			from
				index := index + 1
			until
				after or else bag[item] > 0
			loop
				index := index + 1
			end
		end

end

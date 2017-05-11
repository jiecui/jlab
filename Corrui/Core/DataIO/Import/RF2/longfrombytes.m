function l = longfrombytes(bytes)
%returns a double that has the value of a long made up of four bytes
	l = bitshift(bytes(4), 24) + bitshift(bytes(3), 16) + bitshift(bytes(2), 8) + bytes(1);

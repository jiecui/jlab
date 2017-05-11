function s = shortfrombytes(bytes)
%returns a double that has the value of a short made up of two bytes
	s = bitshift(bytes(2), 8) + bytes(1); 

static void*
memset(void* Dest, int Pattern, size_t NumBytes)
{
	char* DestByte = Dest;
	char ByteValue = (char)Pattern;
	while(NumBytes > 0)
	{
		*DestByte = ByteValue;
		DestByte += 1;
		NumBytes -= 1;
	}
	void* Result = (void*)DestByte;
	return Result;
}

static void*
memcpy(void* Destination, void* Source, size_t NumBytes)
{
	char* DestByte = Destination;
	char* SourceByte = Source;
	while(NumBytes > 0)
	{
		*DestByte = *SourceByte;
		DestByte += 1;
		SourceByte += 1;
		NumBytes -= 1;
	}
	void* Result = DestByte;
	return Result;
}

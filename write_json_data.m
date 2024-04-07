function write_json_data(data, jsonFileName)
	try
		jsonStr = jsonencode(data, "PrettyPrint", true);
		fileID = fopen(jsonFileName, "w");
		fprintf(fileID, "%s", jsonStr);
		fclose(fileID);
	catch
		error('fail!');
	end
end

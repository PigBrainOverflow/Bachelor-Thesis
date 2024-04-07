function data = read_json_data(jsonFileName)
    try
        jsonStr = fileread(jsonFileName);
        data = jsondecode(jsonStr);
    catch
        error('fail!');
    end
end

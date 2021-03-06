class Projects
    
    # @!parse attr_accessor :alive, :code, :code_alias_1, :code_alias_2, :id, :name
    attr_accessor :alive, :code, :code_alias_1, :code_alias_2, :id, :name

    # @!parse attr_accessor :name_alias_1, :name_alias_2, :project_keywords, :fields
    attr_accessor :name_alias_1, :name_alias_2, :project_keywords, :fields
    
    # Creates a Projects object
    #
    # @param args  [String]
    # @return [Projects object]
    #
    # @example 
    #         proj =  Projects.new
    #         proj =  Projects.new('My Project','1234.00')
    def initialize(*args)
        
        if args.length > 1 #We only want one arguement or 2 non-null ones
            unless args.length == 2 && !args.include?(nil) && (args[0].is_a?(String) || args[0].is_a?(Integer)) && (args[1].is_a?(String) || args[1].is_a?(Integer))
                warn "Argument Error:\n\tExpected either\n\t1. No Arguments\n\t2. A Hash\n\t" + 
                     "3. Two separate string arguments." +
                     " e.g. Projects.new(name,code) in that order." + 
                     "\n\tInstead got #{args.inspect} => Creating empty ProjectKeywords object."
            else
                #grab the agruments and set up the json object
                json_obj = {"name" => args[0].to_s, "code" => args[1].to_s}
            end
        else
            json_obj = Validator::validate_argument(args.first,'Projects')
        end
        @alive = json_obj['alive']
        @code = json_obj['code']
        @code_alias_1 = json_obj['code_alias_1']
        @code_alias_2 = json_obj['code_alias_2']
        @id = json_obj['id']
        @name = json_obj['name']
        @name_alias_1 = json_obj['name_alias_1']
        @name_alias_2 = json_obj['name_alias_2']
        @project_keywords = []
        @fields = []
        @albums = []

        if json_obj['projectKeywords'].is_a?(Array) && !json_obj['projectKeywords'].empty?
            #convert each of the nested project keywords into objects
            #This is not a Fields noun. Its just a C struct holding the
            #data we need for the nested resource
            proj_keyword = Struct.new(:id)
            @project_keywords = json_obj['projectKeywords'].map do |item|
                proj_keyword.new(item['id'])
            end
        end

        if json_obj['fields'].is_a?(Array) && !json_obj['fields'].empty?
            #You get the idea...
            field = Struct.new(:id, :values)
            @fields = json_obj['fields'].map do |item|
                field.new(item['id'], item['values'])
            end
        end

        if json_obj['albums'].is_a?(Array) && !json_obj['albums'].empty?
            nested_album = Struct.new(:id)
            @albums = json_obj['albums'].map do |item|
                nested_album.new(item['id'])
            end
        end

    end

    def json
        json_data = Hash.new
        json_data[:alive] = @alive                               unless @alive.nil?
        json_data[:code] = @code                                 unless @code.nil?
        json_data[:code_alias_1] = @code_alias_1                 unless @code_alias_1.nil?
        json_data[:code_alias_2] = @code_alias_2                 unless @code_alias_2.nil?
        json_data[:id]= @id                                      unless @id.nil?
        json_data[:name] = @name                                 unless @name.nil?
        json_data[:name_alias_1] = @name_alias_1                 unless @name_alias_1.nil?
        json_data[:name_alias_2] = @name_alias_2                 unless @name_alias_2.nil?

        unless @project_keywords.empty?
            json_data[:projectKeywords] = @project_keywords.map do |item|
                item.to_h
            end
        end

        unless @fields.empty?
            json_data[:fields] = @fields.map do |item|
                item.to_h
            end
        end

        unless @albums.empty?
            json_data[:albums] = @albums.map do |item|
                item.to_h
            end
        end

        return json_data            
    end

end

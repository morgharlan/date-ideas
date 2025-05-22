class DateIdeasController < ApplicationController

  def index
    # This is your main input form page
  end

  def generate
    @preferences = {
      budget: params[:budget],
      time_of_day: params[:time_of_day],
      setting: params[:setting],
      effort: params[:effort],
      location: params[:location],
      additional_notes: params[:additional_notes]
    }
    
    # Generate date idea directly in controller
    @generated_date = generate_ai_date(@preferences)
    
    render :result
  end

  def show
    @date_idea = DateIdea.find(params[:id])
  end

  private

  def generate_ai_date(preferences)
    require 'net/http'
    require 'json'
    
    puts "=== DEBUG: Starting AI generation ==="
    puts "API Key present: #{ENV['OPENAI_API_KEY'].present?}"
    puts "API Key length: #{ENV['OPENAI_API_KEY']&.length}"
    puts "Preferences: #{preferences.inspect}"
    
    uri = URI('https://api.openai.com/v1/chat/completions')
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{ENV['OPENAI_API_KEY']}"
    request['Content-Type'] = 'application/json'
    
    prompt = build_prompt(preferences)
    puts "=== PROMPT BEING SENT ==="
    puts prompt
    puts "========================="
    
    request.body = {
      model: "gpt-4o-mini",
      messages: [{ role: "user", content: prompt }],
      max_tokens: 500,
      temperature: 0.8
    }.to_json
    
    begin
      puts "=== Making API call ==="
      response = http.request(request)
      puts "Response code: #{response.code}"
      puts "Response body: #{response.body[0..500]}..." # First 500 chars
      
      if response.code == '200'
        result = JSON.parse(response.body)
        content = result.dig("choices", 0, "message", "content")
        puts "=== AI RESPONSE ==="
        puts content
        puts "=================="
        parse_ai_response(content, preferences)
      else
        puts "=== API ERROR ==="
        puts "Error: #{response.body}"
        puts "================="
        Rails.logger.error "OpenAI API Error: #{response.body}"
        fallback_response(preferences)
      end
    rescue => e
      puts "=== EXCEPTION ==="
      puts "Exception: #{e.message}"
      puts "================="
      Rails.logger.error "API Error: #{e.message}"
      fallback_response(preferences)
    end
  end

  def build_prompt(preferences)
    budget_text = case preferences[:budget]
                  when 'free' then 'Free ($0)'
                  when 'low' then 'Low budget ($1-50)'
                  when 'medium' then 'Medium budget ($51-150)'
                  when 'high' then 'High budget ($151-300)'
                  when 'luxury' then 'Luxury budget ($300+)'
                  else 'Flexible budget'
                  end
    
    location = preferences[:location].presence || "a major city"
    
    <<~PROMPT
      Create a detailed and specific date idea with these requirements:
      
      Location: #{location}
      Budget: #{budget_text}
      Time of day: #{preferences[:time_of_day] || 'any time'}
      Setting: #{preferences[:setting] || 'indoor or outdoor'}
      Effort level: #{preferences[:effort] || 'any effort level'}
      Additional preferences: #{preferences[:additional_notes]}
      
      Provide:
      1. A creative, specific title
      2. A brief but detailed description (2-3 sentences with specific venue types/activities)
      3. A step-by-step plan with specific locations, activities, and timing
      
      Be SPECIFIC - include actual venue types, specific activities, approximate timing, and real details someone could follow.
      
      Format exactly like this:
      
      TITLE: [Specific creative title]
      
      DESCRIPTION: [2-3 sentences with specific details about venues and activities]
      
      PLAN: 
      1. [Specific first step with location/venue type]
      2. [Specific second step with timing and activity]
      3. [Specific third step with details]
      4. [Specific fourth step]
      5. [Optional fifth step]
    PROMPT
  end

  def parse_ai_response(content, preferences)
    puts "=== RAW AI CONTENT ==="
    puts content
    puts "======================"
    
    # Try multiple parsing approaches
    title = extract_section(content, 'TITLE') || 
            extract_between_markers(content, '**', '**') ||
            content.lines.first&.strip&.gsub(/^\*\*|\*\*$/, '') ||
            "Surprise Date in #{preferences[:location]}"
    
    description = extract_section(content, 'DESCRIPTION') || 
                  extract_paragraph_after_title(content) ||
                  "A personalized date experience just for you!"
    
    plan = extract_section(content, 'PLAN') || 
           extract_section(content, 'STEPS') ||
           extract_numbered_list(content) ||
           "Your custom date plan will be revealed!"

    {
      title: title,
      description: description,
      detailed_plan: plan,
      budget: estimate_budget(preferences[:budget]),
      time_of_day: preferences[:time_of_day],
      setting: preferences[:setting],
      effort: preferences[:effort],
      location: preferences[:location],
      preferences_used: preferences
    }
  end

  def extract_section(content, section_name)
    regex = /#{section_name}:\s*(.*?)(?=\n[A-Z]+:|$)/m
    match = content.match(regex)
    match ? match[1].strip : nil
  end

  def extract_between_markers(content, start_marker, end_marker)
    regex = /#{Regexp.escape(start_marker)}(.*?)#{Regexp.escape(end_marker)}/m
    match = content.match(regex)
    match ? match[1].strip : nil
  end

  def extract_paragraph_after_title(content)
    lines = content.lines.map(&:strip)
    # Find first non-empty line after title
    lines[1..-1]&.find { |line| line.length > 20 }
  end

  def extract_numbered_list(content)
    # Extract numbered steps or bullet points
    lines = content.lines.map(&:strip)
    steps = lines.select { |line| line.match(/^\d+\.|\*|\-/) }
    steps.any? ? steps.join("\n") : nil
  end

  def estimate_budget(budget_range)
    case budget_range
    when 'free' then 0
    when 'low' then 25
    when 'medium' then 100
    when 'high' then 200
    when 'luxury' then 400
    else 50
    end
  end

  def fallback_response(preferences)
    # Create more detailed fallback responses based on preferences
    location = preferences[:location].presence || 'your city'
    budget_text = case preferences[:budget]
                  when 'free' then 'free'
                  when 'low' then 'budget-friendly'
                  when 'medium' then 'moderately-priced'
                  when 'high' then 'upscale'
                  when 'luxury' then 'luxury'
                  else 'flexible budget'
                  end

    setting_activities = if preferences[:setting] == 'outdoor'
      ['park walk', 'outdoor market visit', 'scenic drive', 'hiking trail exploration']
    else
      ['museum visit', 'cozy café exploration', 'bookstore browsing', 'art gallery tour']
    end

    activity = setting_activities.sample
    
    detailed_plan = case preferences[:effort]
    when 'low'
      "1. Meet at a convenient location in #{location}\n2. Enjoy a relaxing #{activity}\n3. Find a comfortable spot to chat and connect\n4. Grab a #{budget_text} snack or drink together"
    when 'high'
      "1. Research and plan the perfect #{activity} route in #{location}\n2. Prepare a small surprise or thoughtful detail\n3. Meet early and start your adventure\n4. Document the experience with photos\n5. End with a #{budget_text} meal to discuss your day\n6. Plan your next adventure together"
    else
      "1. Choose a great #{activity} spot in #{location}\n2. Meet and start exploring together\n3. Take your time to enjoy each other's company\n4. Find a nice place for a #{budget_text} treat\n5. Make plans for your next date"
    end

    {
      title: "#{preferences[:time_of_day]&.capitalize} #{activity.split.map(&:capitalize).join(' ')} in #{location.split.map(&:capitalize).join(' ')}",
      description: "A wonderful #{preferences[:time_of_day]} #{preferences[:setting]} date featuring #{activity}. This #{preferences[:effort]}-effort date is perfect for connecting and creating memories together in #{location}.",
      detailed_plan: detailed_plan,
      budget: estimate_budget(preferences[:budget]),
      time_of_day: preferences[:time_of_day],
      setting: preferences[:setting],
      effort: preferences[:effort],
      location: preferences[:location],
      preferences_used: preferences,
      api_error: true  # This flags that it's a fallback
    }
  end

  def save_generated_date
    # Get the date data from the form parameters
    date_data = params.require(:date_idea).permit(:title, :description, :detailed_plan, :budget, :time_of_day, :setting, :effort, :location)
    
    # Create a new DateIdea in the database
    @date_idea = DateIdea.create!(
      title: date_data[:title],
      description: date_data[:description],
      budget: date_data[:budget],
      time_of_day: date_data[:time_of_day],
      setting: date_data[:setting],
      effort: date_data[:effort],
      city: date_data[:location]
    )
    
    # Create a SavedDate for the first user (we'll add proper user auth later)
    @saved_date = SavedDate.create!(
      user: User.first, # Temporary - we'll fix this with authentication
      date_idea: @date_idea,
      note: "Generated on #{Date.current}"
    )
    
    redirect_to saved_dates_path, notice: "Date saved successfully! 🎉"
  end

end

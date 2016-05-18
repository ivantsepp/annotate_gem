module AnnotateGem
  class GemLine

    attr_accessor :name, :original_line, :location, :prev_line_comment, :spec, :options

    def initialize(*args)
      named_params = args.last.respond_to?(:[]) && args.last
      @name = (named_params && named_params[:name]) || args[0]
      @original_line = (named_params && named_params[:original_line]) || args[1]
      @location = (named_params && named_params[:location]) || args[2]
      @prev_line_comment = (named_params && named_params[:prev_line_comment]) || args[3]
      @options = (named_params && named_params[:options]) || named_params
    end

    def comment
      leading_spaces = original_line[0..leading_spaces_count - 1] if leading_spaces_count > 0
      comment = "#{leading_spaces}# #{info}"
    end

    def inline_comment
      "#{original_line.chomp} # #{info}"
    end

    def info
      output = if options[:website_only]
        website
      elsif options[:description_only]
        description
      else
        description_and_website
      end
      output << "\n"
    end

    def should_insert?
      !info.strip.empty? && !already_added_comment && !existing_comment_option
    end

    private

    def already_added_comment
      !options[:inline] && prev_line_comment && prev_line_comment.include?(comment)
    end

    # if there exists a prev_line_comment and the user has specified new_comments_only
    def existing_comment_option
      (options[:new_comments_only] && prev_line_comment) || (options[:inline] && original_line_has_comment?)
    end

    def original_line_has_comment?
      original_line.include?("#")
    end

    def leading_spaces_count
      original_line.length - original_line.lstrip.length
    end

    def description
      "#{spec.summary}" if spec
    end

    def website
      "#{spec.homepage.to_s}" if spec
    end

    def description_and_website
      output = "#{description}"
      output << " (#{website})" unless website.nil? || website.empty?
      output
    end

  end
end

module Fastlane
  module Actions

    class EnsureDependencyAction < Action
      def self.run(params)
        input_name = params[:name]
        input_instructions = params[:installation_instructions]

        path = `which #{input_name}`.chomp
        errorString = "Couldn't find the program `#{input_name}` in any PATH directories:\n" \
                      "$PATH: #{`echo $PATH`.chomp}\n"

        if (input_instructions and not input_instructions.empty?)
          errorString << "\n"
          errorString << "To install this dependency:\n"
          errorString << "#{input_instructions}"
        end

        UI.user_error!(errorString) unless (path and not path.empty?)
        UI.success("Verified dependency `#{input_name}` exists at `#{path}` ✅")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Raises an exception if the dependency is not accessible in the current PATH"
      end

      def self.details
        "Internally, this action uses `which` to confirm that the specified program file is accessible. This is\n" \
        "helpful for ensuring that all dependencies of a particular Fastfile are installed, and allows for providing\n" \
        "installation instructions for how to install the missing dependencies."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :name,
                                       env_name: "FL_ENSURE_DEPENDENCY_NAME",
                                       description: "Program name to verify existence",
                                       verify_block: proc do |value|
                                          UI.user_error!("No program name for ensure_dependency action given, pass using `name: 'programName'`") unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :installation_instructions,
                                       optional: true,
                                       env_name: "FL_ENSURE_DEPENDENCY_INSTALLATION_INSTRUCTIONS",
                                       description: "Optional installation instructions to log to console if program is not found"),
        ]
      end

      def self.authors
        ["johntmcintosh"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end

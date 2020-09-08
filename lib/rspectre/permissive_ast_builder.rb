# frozen_string_literal: true

# See: https://github.com/whitequark/parser/issues/323#issuecomment-253606403
# Solution to: https://github.com/dgollahon/rspectre/issues/17
# See also: https://github.com/whitequark/parser/blob/c25585d8d91f3470d9cdfd6f3b6a553ad9a809fb/lib/parser/builders/default.rb#L2076

module RSpectre
  class PermissiveASTBuilder < ::Parser::Builders::Default
    def string_value(token)
      token.first
    end
  end
end

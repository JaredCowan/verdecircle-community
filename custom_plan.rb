# https://github.com/burke/zeus/blob/master/docs/ruby/modifying.md

require 'zeus/rails'

class CustomPlan < Zeus::Rails

  def test
    require 'simplecov'
    SimpleCov.start 'rails'

    # run the tests
    super
  end
end

Zeus.plan = CustomPlan.new

module PmTools
  class Strategy

    attr_accessor :manager

    def initialize(manager, attributes={})
      @manager = ('PmTools::'+manager.capitalize).constantize.new(attributes)
    end

    def create_task(name, text)
      @manager.create_task(name, text, self)
    end

  end
end

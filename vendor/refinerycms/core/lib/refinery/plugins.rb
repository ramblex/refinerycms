module Refinery
  class Plugins < Array

    def initialize
      @plugins = []
    end

    def find_by_name(name)
      self.detect { |plugin| plugin.name == name }
    end

    def find_by_title(title)
      self.detect { |plugin| plugin.title == title }
    end

    def find_by_model(model)
      model = model.constantize if model.is_a? String
      self.detect { |plugin| plugin.activity.any? {|activity| activity.class == model } }
    end

    def find_activity_by_model(model)
      unless (plugin = find_by_model(model)).nil?
        plugin.activity.detect {|activity| activity.class == model}
      end
    end

    def [](name)
      self.find_by_name(name)
    end

    def self.registered
      @registered_plugins ||= self.new
    end

    def pathnames
      self.collect { |p| p.pathname }.compact
    end

    def names
      self.collect { |p| p.name }
    end

    def titles
      self.collect { |p| p.title }
    end

    def in_menu
      self.reject{ |p| p.hide_from_menu }
    end

    def self.active
      @active_plugins ||= self.new
    end

    def self.always_allowed
      registered.reject { |p| !p.always_allow_access? }
    end

    def self.set_active(names)
      active.clear
      names.each do |name|
        active << registered[name] if registered[name]
      end
    end

  end
end

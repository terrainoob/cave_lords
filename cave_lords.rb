Dir[File.join(__dir__, 'app', '**', '*.rb')].each { |file| require file }
GameWindow.run

Pod::Spec.new do |s|

    s.platforms = { :ios => "8.0", :osx => "10.10" }

    s.name = "JustRequest"
    s.summary = "A URLSession wrapper just for GET and POST"
    s.requires_arc = true

    s.version = "0.5.2"
    s.license = 'MIT'
    s.author = { "Wirawit" => "aun.wirawit@gmail.com" }
    s.homepage = "https://github.com/aunnnn/Just"

    s.source = { :git => "https://github.com/aunnnn/Just.git", :tag => "#{s.version}"}
    s.framework = "Foundation"

    s.source_files = "Just/*.swift"
    s.swift_version = '4.0'
end

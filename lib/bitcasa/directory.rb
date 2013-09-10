module Bitcasa
  class Directory < FuseFS::FuseDir
    def initialize(session, path = '/')
      @session = session
      @path    = path
    end

    def contents(path)
      puts "DEBUG: contents #{path}"
      @session.ls(path).map{|x| x[:name]}
    end

    def file?(path)
      puts "DEBUG: file? #{path}"
      dir, _, file = path.rpartition('/')
      contents = @session.ls(dir)
      if (entry = contents.select{|x| x[:name] == file}[0])
        entry[:type] == :file
      else
        false
      end
    end

    def directory?(path)
      puts "DEBUG: directory? #{path}"
      dir, _, file = path.rpartition('/')
      contents = @session.ls(dir)
      if (entry = contents.select{|x| x[:name] == file}[0])
        entry[:type] == :dir
      else
        false
      end
    end

    def read_file(path)
      puts "DEBUG: read_file #{path}"
      raise "Not implemented"
    end

    def size(path)
      puts "DEBUG: size #{path}"
      dir, _, file = path.rpartition('/')
      contents = @session.ls(dir)
      if (entry = contents.select{|x| x[:name] == file})
        entry[:size]
      else
        0
      end
    end

    #def readdir(ctx, path, filler, offset, ffi)
    #  puts "readdir #{path}"
    #  @session.ls.each do |entry|
    #    puts "- #{entry[:name]}"
    #    mtime = entry[:mtime]
    #    if entry[:type] == :file
    #      stat = RFuse::Stat.file(0777, :uid => 1000, :gid => 1000,
    #        :atime => mtime, :mtime => mtime, :size => entry[:size])
    #    else
    #      stat = RFuse::Stat.directory(0777, :uid => 1000, :gid => 1000,
    #        :atime => mtime, :mtime => mtime, :size => 23)
    #    end
    #    filler.push(entry[:name], stat, 0)
    #  end
    #end

    #def getattr(ctx, path)
    #  puts "Called: getattr #{ctx}, #{path}"
    #  RFuse::Stat.file(0777, :uid => 1000, :gid => 1000,
    #    :atime => mtime, :mtime => mtime, :size => 1048576)
    #end
  end
end

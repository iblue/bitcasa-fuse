module Bitcasa
  class Fuse
    def initialize(session)
      @session = session
    end

    def readdir(ctx, path, filler, offset, ffi)
      puts "readdir #{path}"
      @session.ls.each do |entry|
        puts "- #{entry[:name]}"
        mtime = entry[:mtime]
        if entry[:type] == :file
          stat = RFuse::Stat.file(0777, :uid => 1000, :gid => 1000,
            :atime => mtime, :mtime => mtime, :size => entry[:size])
        else
          stat = RFuse::Stat.directory(0777, :uid => 1000, :gid => 1000,
            :atime => mtime, :mtime => mtime, :size => 23)
        end
        filler.push(entry[:name], stat, 0)
      end
    end
  end
end

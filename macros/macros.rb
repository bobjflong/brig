
require 'mustache'

class Array
  def all_but_last
    self[0..-2].join("-")
  end
  def flat_zip *args
    arg = *args
    zip arg
  end
end

class String
  def using_mustache hash
    Mustache.render(self, hash)
  end
end

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end

module BrigMacros

  def self.display_version
    LispMacro.new 'display-version' do |ast|
      """(Show (cat \"brig v\" version))"""
    end
  end

  def self.cat
    LispMacro.new 'cat' do |ast|
      left = ast[1].to_sxp
      right = ast[2].to_sxp
      """(Send (Cons :+ #{right}) #{left})"""
    end
  end

  def self.arg
    LispMacro.new 'arg' do |ast|
      if ast.length == 0
        """arg"""
      else
        pos = ast[1].to_sxp
        """(Send (Cons :at #{pos}) arg)"""
      end
    end
  end

  def self.eq
    LispMacro.new 'eq?' do |ast|
      left = ast[1].to_sxp
      right = ast[2].to_sxp
      """(Send (Cons \"==\" #{left}) #{right})"""
    end
  end

  #(case x (1 b1) (2 b2))
  def self.case
    LispMacro.new 'case' do |ast|
      pred = ast[1].to_sxp
      res = ""
      ast.drop(2).each do |b|
        res += """
          (If (eq? #{pred} #{b[0].to_sxp})
              #{b[1].to_sxp}
              null
          )
        """
      end
      res
    end
  end

  def self.null_warning
    LispMacro.new 'exit-if-null' do |ast|
      possible = ast[1].to_sxp
      msg = ast[2].to_sxp
      """
      (If (Send \"nil?\" #{possible})
        (Send (Cons \"fail\" #{msg}) :Kernel)
        null
      )
      """
    end
  end

  def self.create_file
    LispMacro.new 'create-timestamped-file' do |ast|
      name = ast[1].to_sxp
      file_args = """
        (Send :flatten (Cons (Cons :new (cat \"./posts/\" (cat #{name} (cat (cat \"-\" (Send
        \"to_s\" (Send \"to_i\" (Send :now :Time)))) \"\")))) \"w\"))
      """
      """
        (Send #{file_args} :File)
      """
    end
  end

  def self.empty_list
    LispMacro.new 'empty-list' do |ast|
      """(Send :new :Array)"""
    end
  end

  def self.not
    LispMacro.new 'not' do |ast|
      """(Send \"blank?\" #{ast[1].to_sxp})"""
    end
  end

  def self.newline
    LispMacro.new 'newline' do |ast|
      """(Show \"\")"""
    end
  end

  def self.get_entered_name
    LispMacro.new 'get-entered-name' do |ast|
      if ARGV[1]
        """\"#{ARGV[1..-1].join "-"}\""""
      else
        """null"""
      end
    end
  end

  #fill-tag _ in _
  def self.fill_tag
    LispMacro.new 'fill-tag' do |ast|
      tag = ast[1].to_sxp
      template = ast[3].to_sxp
      """
        (Send (Cons \"using_mustache\" #{tag}) #{template})
      """
    end
  end

  def self.index_location
    LispMacro.new 'index-html' do |ast|
      """\"./site/index.html\""""
    end
  end

  def self.add_to_hash
    LispMacro.new 'add-to-hash' do |ast|
      hash = ast[1].to_sxp
      key = ast[2].to_sxp
      val = ast[3].to_sxp
      """(Send (Cons \"[]=\" (Cons #{key} #{val})) #{hash})"""
    end
  end

  def self.let_many
    LispMacro.new 'LetMany' do |ast|
      res = ""
      ast.drop(1).each do |let|
        res += [:Let, let.first, let.drop(1).first].to_sxp
      end
      res
    end
  end

  def self.macros
    MacroList.new [BrigMacros.display_version, BrigMacros.cat, BrigMacros.arg, BrigMacros.case, BrigMacros.eq,BrigMacros.null_warning, BrigMacros.create_file,
    BrigMacros.empty_list, BrigMacros.not, BrigMacros.newline,
    BrigMacros.get_entered_name, BrigMacros.fill_tag, BrigMacros.index_location,
    BrigMacros.add_to_hash, BrigMacros.let_many]
  end

end

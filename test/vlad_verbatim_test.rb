require 'test_helper'

class VladVerbatimTest < Test::Unit::TestCase

  should "find front-matter" do
    fm = Vlad::Verbatim.front_matter(template)
    assert_equal "someone", fm['owner']
    assert_equal "0744",    fm['mode']
  end

  should "run remote chmod" do
    Vlad::Verbatim.expects(:run).with(regexp_matches(/chmod.*0755/))
    Vlad::Verbatim.set_file_mode('/etc/booga.conf', '0755')
  end

  should "run remote chown" do
    Vlad::Verbatim.expects(:run).with(regexp_matches(/chown.*brian/))
    Vlad::Verbatim.set_file_owner('/etc/booga.conf', 'brian')
  end

  should "check" do
    assert Vlad::Verbatim.check
  end


end

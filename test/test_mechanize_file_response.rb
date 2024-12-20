# frozen_string_literal: true
require 'mechanize_curl/test_case'

class TestMechanizeFileResponse < MechanizeCurl::TestCase
  def test_file_path
    res = MechanizeCurl::FileResponse.new("/path/to/foo.html")
    assert_equal("/path/to/foo.html", res.file_path)
  end

  def test_content_type
    Tempfile.open %w[pi .nothtml] do |tempfile|
      res = MechanizeCurl::FileResponse.new tempfile.path
      assert_nil res['content-type']
    end

    Tempfile.open %w[pi .xhtml] do |tempfile|
      res = MechanizeCurl::FileResponse.new tempfile.path
      assert_equal 'text/html', res['content-type']
    end

    Tempfile.open %w[pi .html] do |tempfile|
      res = MechanizeCurl::FileResponse.new tempfile.path
      assert_equal 'text/html', res['Content-Type']
    end
  end

  def test_read_body
    Tempfile.open %w[pi .html] do |tempfile|
      tempfile.write("asdfasdfasdf")
      tempfile.close

      res = MechanizeCurl::FileResponse.new(tempfile.path)
      res.read_body do |input|
        assert_equal("asdfasdfasdf", input)
      end
    end
  end

  def test_read_body_does_not_allow_command_injection
    skip if windows?
    in_tmpdir do
      FileUtils.touch('| ruby -rfileutils -e \'FileUtils.touch("vul.txt")\'')
      res = MechanizeCurl::FileResponse.new('| ruby -rfileutils -e \'FileUtils.touch("vul.txt")\'')
      res.read_body { |_| }
      refute_operator(File, :exist?, "vul.txt")
    end
  end
end

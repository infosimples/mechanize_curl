# frozen_string_literal: true
require 'mechanize_curl/test_case'

class TestMechanizeDownload < MechanizeCurl::TestCase

  def setup
    super

    @parser = MechanizeCurl::Download
  end

  def test_body
    uri = URI.parse 'http://example/foo.html'
    body_io = StringIO.new '0123456789'

    download = @parser.new uri, nil, body_io

    assert_equal '0123456789', download.body
    assert_equal 0, download.body_io.pos
  end

  def test_save_string_io
    uri = URI.parse 'http://example/foo.html'
    body_io = StringIO.new '0123456789'

    download = @parser.new uri, nil, body_io

    in_tmpdir do
      filename = download.save

      assert File.exist? 'foo.html'
      assert_equal "foo.html", filename
    end
  end

  def test_save_bang
    uri = URI.parse 'http://example/foo.html'
    body_io = StringIO.new '0123456789'

    download = @parser.new uri, nil, body_io

    in_tmpdir do
      filename = download.save!

      assert File.exist? 'foo.html'
      assert_equal "foo.html", filename
    end
  end

  def test_save_bang_does_not_allow_command_injection
    skip if windows?
    uri = URI.parse 'http://example/foo.html'
    body_io = StringIO.new '0123456789'

    download = @parser.new uri, nil, body_io

    in_tmpdir do
      download.save!('| ruby -rfileutils -e \'FileUtils.touch("vul.txt")\'')
      refute_operator(File, :exist?, "vul.txt")
    end
  end

  def test_save_tempfile
    uri = URI.parse 'http://example/foo.html'
    Tempfile.open @NAME do |body_io|
      body_io.unlink
      body_io.write '0123456789'

      body_io.flush
      body_io.rewind

      download = @parser.new uri, nil, body_io

      in_tmpdir do
        filename = download.save

        assert File.exist? 'foo.html'
        assert_equal "foo.html", filename

        filename = download.save

        assert File.exist? 'foo.html.1'
        assert_equal "foo.html.1", filename

        filename = download.save

        assert File.exist? 'foo.html.2'
        assert_equal "foo.html.2", filename
      end
    end
  end

  def test_filename
    uri = URI.parse 'http://example/foo.html'
    body_io = StringIO.new '0123456789'

    download = @parser.new uri, nil, body_io

    assert_equal "foo.html", download.filename
  end
end


# frozen_string_literal: true
require 'mechanize_curl/test_case'

class TestMechanizeFile < MechanizeCurl::TestCase

  def setup
    super

    @parser = MechanizeCurl::File
  end

  def test_save
    uri = URI 'http://example/name.html'
    page = MechanizeCurl::File.new uri, nil, '0123456789'

    Dir.mktmpdir do |dir|
      Dir.chdir dir do
        filename = page.save 'test.html'

        assert File.exist? 'test.html'
        assert_equal '0123456789', File.read('test.html')
        assert_equal "test.html", filename

        filename = page.save 'test.html'

        assert File.exist? 'test.html.1'
        assert_equal '0123456789', File.read('test.html.1')
        assert_equal "test.html.1", filename

        filename = page.save 'test.html'

        assert File.exist? 'test.html.2'
        assert_equal '0123456789', File.read('test.html.2')
        assert_equal "test.html.2", filename
      end
    end
  end

  def test_save_default
    uri = URI 'http://example/test.html'
    page = MechanizeCurl::File.new uri, nil, ''

    Dir.mktmpdir do |dir|
      Dir.chdir dir do
        filename = page.save

        assert File.exist? 'test.html'
        assert_equal "test.html", filename

        filename = page.save

        assert File.exist? 'test.html.1'
        assert_equal "test.html.1", filename

        filename = page.save

        assert File.exist? 'test.html.2'
        assert_equal "test.html.2", filename
      end
    end
  end

  def test_save_default_dots
    uri = URI 'http://localhost/../test.html'
    page = MechanizeCurl::File.new uri, nil, ''

    Dir.mktmpdir do |dir|
      Dir.chdir dir do
        filename = page.save
        assert File.exist? 'test.html'
        assert_equal "test.html", filename

        filename = page.save
        assert File.exist? 'test.html.1'
        assert_equal "test.html.1", filename
      end
    end
  end

  def test_filename
    uri = URI 'http://localhost/test.html'
    page = MechanizeCurl::File.new uri, nil, ''

    assert_equal "test.html", page.filename
  end

  def test_save_overwrite
    uri = URI 'http://example/test.html'
    page = MechanizeCurl::File.new uri, nil, ''

    Dir.mktmpdir do |dir|
      Dir.chdir dir do
        filename = page.save 'test.html'

        assert File.exist? 'test.html'
        assert_equal "test.html", filename

        filename = page.save! 'test.html'

        assert File.exist? 'test.html'
        refute File.exist? 'test.html.1'
        assert_equal "test.html", filename
      end
    end
  end

  def test_save_bang_does_not_allow_command_injection
    skip if windows?
    uri = URI 'http://example/test.html'
    page = MechanizeCurl::File.new uri, nil, ''

    in_tmpdir do
      page.save!('| ruby -rfileutils -e \'FileUtils.touch("vul.txt")\'')
      refute_operator(File, :exist?, "vul.txt")
    end
  end
end


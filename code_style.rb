# -*- coding: utf-8 -*- #

require "rouge"

module Rouge
  module Themes
    class CorrectGithub < CSSTheme
      name 'correct_github'

      style Comment::Multiline,               :fg => '#969896', :italic => true
      style Comment::Preproc,                 :fg => '#969896', :bold => true
      style Comment::Single,                  :fg => '#969896', :italic => true
      style Comment::Special,                 :fg => '#969896', :italic => true, :bold => true
      style Comment,                          :fg => '#969896', :italic => true
      style Error,                            :fg => '#a61717', :bg => '#e3d2d2'
      style Generic::Deleted,                 :fg => '#000000', :bg => '#ffdddd'
      style Generic::Emph,                    :fg => '#000000', :italic => true
      style Generic::Error,                   :fg => '#aa0000'
      style Generic::Heading,                 :fg => '#999999'
      style Generic::Inserted,                :fg => '#000000', :bg => '#ddffdd'
      style Generic::Output,                  :fg => '#888888'
      style Generic::Prompt,                  :fg => '#555555'
      style Generic::Strong,                  :bold => true
      style Generic::Subheading,              :fg => '#aaaaaa'
      style Generic::Traceback,               :fg => '#aa0000'
      style Keyword::Constant,                :fg => '#a71d5d', :bold => false
      style Keyword::Declaration,             :fg => '#a71d5d', :bold => false
      style Keyword::Namespace,               :fg => '#000000', :bold => false
      style Keyword::Pseudo,                  :fg => '#000000', :bold => false
      style Keyword::Reserved,                :fg => '#a71d5d', :bold => false
      style Keyword::Type,                    :fg => '#445588', :bold => false
      style Keyword,                          :fg => '#a71d5d', :bold => false
      style Literal::Number::Float,           :fg => '#0086b3'
      style Literal::Number::Hex,             :fg => '#0086b3'
      style Literal::Number::Integer::Long,   :fg => '#0086b3'
      style Literal::Number::Integer,         :fg => '#0086b3'
      style Literal::Number::Oct,             :fg => '#0086b3'
      style Literal::Number,                  :fg => '#0086b3'
      style Literal::String::Backtick,        :fg => '#d14'
      style Literal::String::Char,            :fg => '#d14'
      style Literal::String::Doc,             :fg => '#d14'
      style Literal::String::Double,          :fg => '#183691'
      style Literal::String::Escape,          :fg => '#d14'
      style Literal::String::Heredoc,         :fg => '#d14'
      style Literal::String::Interpol,        :fg => '#d14'
      style Literal::String::Other,           :fg => '#183691'
      style Literal::String::Regex,           :fg => '#009926'
      style Literal::String::Single,          :fg => '#183691'
      style Literal::String::Symbol,          :fg => '#990073'
      style Literal::String,                  :fg => '#183691'
      style Name::Attribute,                  :fg => '#008080'
      style Name::Builtin::Pseudo,            :fg => '#999999'
      style Name::Builtin,                    :fg => '#0086B3'
      style Name::Class,                      :fg => '#445588', :bold => true
      style Name::Constant,                   :fg => '#0086b3'
      style Name::Decorator,                  :fg => '#3c5d5d', :bold => true
      style Name::Entity,                     :fg => '#800080'
      style Name::Exception,                  :fg => '#333', :bold => true
      style Name::Function,                   :fg => '#333', :bold => false
      style Name::Label,                      :fg => '#333', :bold => true
      style Name::Namespace,                  :fg => '#555555'
      style Name::Tag,                        :fg => '#000080'
      style Name::Variable::Class,            :fg => '#008080'
      style Name::Variable::Global,           :fg => '#008080'
      style Name::Variable::Instance,         :fg => '#008080'
      style Name::Variable,                   :fg => '#008080'
      style Operator::Word,                   :fg => '#000000', :bold => true
      style Operator,                         :fg => '#a71d5d', :bold => false
      style Text::Whitespace,                 :fg => '#bbbbbb'
      style Text,                             :bg => '#f8f8f8'
    end
  end
end
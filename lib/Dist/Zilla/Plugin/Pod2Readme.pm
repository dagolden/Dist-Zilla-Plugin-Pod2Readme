use 5.008;
use strict;
use warnings;

package Dist::Zilla::Plugin::Pod2Readme;
# ABSTRACT: Generate README from Pod, as simply as possible

our $VERSION = '0.005';

use Dist::Zilla 5 ();

use Moose;
with 'Dist::Zilla::Role::FileGatherer';

=attr filename

Name for the generated README.  Defaults to 'README'.

=cut

has filename => (
    is      => 'ro',
    isa     => 'Str',
    default => 'README'
);

=attr source_filename

The file from which to extract POD for the content of the README.  Defaults to
the main module of the distribution.

=cut

has source_filename => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub { $_[0]->zilla->main_module->name }
);

sub gather_files {
    my $self = shift;

    require Dist::Zilla::File::FromCode;
    require Pod::Text;
    require List::Util;

    $self->add_file(
        Dist::Zilla::File::FromCode->new(
            {
                name => $self->filename,
                code => sub {
                    my $parser = Pod::Text->new();
                    $parser->output_string( \( my $text ) );
                    my $filename = $self->source_filename;
                    my $source = List::Util::first { $_->name eq $filename } @{ $self->zilla->files };
                    $self->log_fatal("File $filename not found to extract readme")
                      unless defined $source;
                    my $pod = $source->content;
                    $parser->parse_string_document($pod);
                    return $text;
                },
            }
        )
    );

    return;
}

1;

=for Pod::Coverage gather_files

=head1 SYNOPSIS

    # in dist.ini
    [Pod2Readme]

=head1 DESCRIPTION

This module generates a text F<README> file from the POD of your
main module.

=head1 SEE ALSO

=for :list
* L<Dist::Zilla::Plugin::Readme> - bare bones boilerplate README
* L<Dist::Zilla::Plugin::ReadmeFromPod> - overly complex version of this
* L<Dist::Zilla::Plugin::ReadmeAnyFromPod> - overly complex, but does
  multiple file types

=cut

# vim: ts=4 sts=4 sw=4 et tw=75:

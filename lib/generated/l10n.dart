// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Paramètres`
  String get settings {
    return Intl.message(
      'Paramètres',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Mode Nuit`
  String get night_mode {
    return Intl.message(
      'Mode Nuit',
      name: 'night_mode',
      desc: '',
      args: [],
    );
  }

  /// `Paramètre de l'application`
  String get application_settings {
    return Intl.message(
      'Paramètre de l\'application',
      name: 'application_settings',
      desc: '',
      args: [],
    );
  }

  /// `Changer de langue`
  String get change_language {
    return Intl.message(
      'Changer de langue',
      name: 'change_language',
      desc: '',
      args: [],
    );
  }

  /// `Avis`
  String get rate {
    return Intl.message(
      'Avis',
      name: 'rate',
      desc: '',
      args: [],
    );
  }

  /// `Laisser un commentaire`
  String get leave_feedback {
    return Intl.message(
      'Laisser un commentaire',
      name: 'leave_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Suivre`
  String get follow {
    return Intl.message(
      'Suivre',
      name: 'follow',
      desc: '',
      args: [],
    );
  }

  /// `Paratger Application`
  String get share_application {
    return Intl.message(
      'Paratger Application',
      name: 'share_application',
      desc: '',
      args: [],
    );
  }

  /// `Suivre sur Twitter`
  String get follow_on_twitter {
    return Intl.message(
      'Suivre sur Twitter',
      name: 'follow_on_twitter',
      desc: '',
      args: [],
    );
  }

  /// `Suivre sur Instagram`
  String get follow_on_instagram {
    return Intl.message(
      'Suivre sur Instagram',
      name: 'follow_on_instagram',
      desc: '',
      args: [],
    );
  }

  /// `Aimé la page Facebook`
  String get like_on_facebook {
    return Intl.message(
      'Aimé la page Facebook',
      name: 'like_on_facebook',
      desc: '',
      args: [],
    );
  }

  /// `Apropos`
  String get about {
    return Intl.message(
      'Apropos',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Condtions`
  String get terms_of_use {
    return Intl.message(
      'Condtions',
      name: 'terms_of_use',
      desc: '',
      args: [],
    );
  }

  /// `A propos de l'Application`
  String get about_application {
    return Intl.message(
      'A propos de l\'Application',
      name: 'about_application',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Paramètre de compte`
  String get account_settings {
    return Intl.message(
      'Paramètre de compte',
      name: 'account_settings',
      desc: '',
      args: [],
    );
  }

  /// `Quitter`
  String get log_out {
    return Intl.message(
      'Quitter',
      name: 'log_out',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Erreur`
  String get error {
    return Intl.message(
      'Erreur',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Succès`
  String get success {
    return Intl.message(
      'Succès',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Bon retour`
  String get welcome_back {
    return Intl.message(
      'Bon retour',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Se connecter!`
  String get log_in_title {
    return Intl.message(
      'Se connecter!',
      name: 'log_in_title',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Mot de passe`
  String get password {
    return Intl.message(
      'Mot de passe',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Confirmer le mot de passe`
  String get password_confirm {
    return Intl.message(
      'Confirmer le mot de passe',
      name: 'password_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Prénom`
  String get first_name {
    return Intl.message(
      'Prénom',
      name: 'first_name',
      desc: '',
      args: [],
    );
  }

  /// `Nom`
  String get last_name {
    return Intl.message(
      'Nom',
      name: 'last_name',
      desc: '',
      args: [],
    );
  }

  /// `Utilisateur`
  String get username {
    return Intl.message(
      'Utilisateur',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Mot de passe oublié?`
  String get forgot_your_password {
    return Intl.message(
      'Mot de passe oublié?',
      name: 'forgot_your_password',
      desc: '',
      args: [],
    );
  }

  /// `Se connecter`
  String get log_in {
    return Intl.message(
      'Se connecter',
      name: 'log_in',
      desc: '',
      args: [],
    );
  }

  /// `Pas de compte ??`
  String get do_not_have_an_account {
    return Intl.message(
      'Pas de compte ??',
      name: 'do_not_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Avez-vous un compte ?`
  String get do_you_have_an_account {
    return Intl.message(
      'Avez-vous un compte ?',
      name: 'do_you_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `S'inscrire maintenant`
  String get sign_up_now {
    return Intl.message(
      'S\'inscrire maintenant',
      name: 'sign_up_now',
      desc: '',
      args: [],
    );
  }

  /// `S'inscrire`
  String get sign_up {
    return Intl.message(
      'S\'inscrire',
      name: 'sign_up',
      desc: '',
      args: [],
    );
  }

  /// `Renitialiser le mot de passe`
  String get reset_password {
    return Intl.message(
      'Renitialiser le mot de passe',
      name: 'reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Un problème inattendu s'est produit. Veuillez réessayer plus tard.`
  String get an_unexpected_problem_has_occurred {
    return Intl.message(
      'Un problème inattendu s\'est produit. Veuillez réessayer plus tard.',
      name: 'an_unexpected_problem_has_occurred',
      desc: '',
      args: [],
    );
  }

  /// `Le lien de réinitialisation du mot de passe a été envoyé. Veuillez vérifier votre adresse e-mail.`
  String get password_reset_link_has_been_sent {
    return Intl.message(
      'Le lien de réinitialisation du mot de passe a été envoyé. Veuillez vérifier votre adresse e-mail.',
      name: 'password_reset_link_has_been_sent',
      desc: '',
      args: [],
    );
  }

  /// `Ce champ ne peut pas être vide.`
  String get this_field_cannot_be_empty {
    return Intl.message(
      'Ce champ ne peut pas être vide.',
      name: 'this_field_cannot_be_empty',
      desc: '',
      args: [],
    );
  }

  /// `Ce champ doit être défini sur vrai.`
  String get this_field_must_be_set_to_true {
    return Intl.message(
      'Ce champ doit être défini sur vrai.',
      name: 'this_field_must_be_set_to_true',
      desc: '',
      args: [],
    );
  }

  /// `La valeur doit être supérieure ou égale à {min}`
  String value_must_be_greater_than_or_equal_to(Object min) {
    return Intl.message(
      'La valeur doit être supérieure ou égale à $min',
      name: 'value_must_be_greater_than_or_equal_to',
      desc: '',
      args: [min],
    );
  }

  /// `La valeur doit être inférieure ou égale à {max}`
  String value_must_be_less_than_or_equal_to(Object max) {
    return Intl.message(
      'La valeur doit être inférieure ou égale à $max',
      name: 'value_must_be_less_than_or_equal_to',
      desc: '',
      args: [max],
    );
  }

  /// `La valeur doit avoir une longueur supérieure ou égale à {minLength}`
  String value_must_have_a_length_greater_than_or_equal_to(Object minLength) {
    return Intl.message(
      'La valeur doit avoir une longueur supérieure ou égale à $minLength',
      name: 'value_must_have_a_length_greater_than_or_equal_to',
      desc: '',
      args: [minLength],
    );
  }

  /// `La valeur doit avoir une longueur inférieure ou égale à {maxLength}`
  String value_must_have_a_length_less_than_or_equal_to(Object maxLength) {
    return Intl.message(
      'La valeur doit avoir une longueur inférieure ou égale à $maxLength',
      name: 'value_must_have_a_length_less_than_or_equal_to',
      desc: '',
      args: [maxLength],
    );
  }

  /// `Ce champ nécessite une adresse e-mail valide.`
  String get this_field_requires_a_valid_email_address {
    return Intl.message(
      'Ce champ nécessite une adresse e-mail valide.',
      name: 'this_field_requires_a_valid_email_address',
      desc: '',
      args: [],
    );
  }

  /// `Ce champ nécessite une URL valide.`
  String get this_field_requires_a_valid_url_address {
    return Intl.message(
      'Ce champ nécessite une URL valide.',
      name: 'this_field_requires_a_valid_url_address',
      desc: '',
      args: [],
    );
  }

  /// `La valeur ne correspond pas au modèle.`
  String get value_does_not_match_pattern {
    return Intl.message(
      'La valeur ne correspond pas au modèle.',
      name: 'value_does_not_match_pattern',
      desc: '',
      args: [],
    );
  }

  /// `La valeur doit être numérique.`
  String get value_must_be_numeric {
    return Intl.message(
      'La valeur doit être numérique.',
      name: 'value_must_be_numeric',
      desc: '',
      args: [],
    );
  }

  /// `Ce champ nécessite un numéro de carte de crédit valide.`
  String get this_field_requires_a_valid_credit_card_number {
    return Intl.message(
      'Ce champ nécessite un numéro de carte de crédit valide.',
      name: 'this_field_requires_a_valid_credit_card_number',
      desc: '',
      args: [],
    );
  }

  /// `Ce champ nécessite une IP valide.`
  String get this_field_requires_a_valid_ip {
    return Intl.message(
      'Ce champ nécessite une IP valide.',
      name: 'this_field_requires_a_valid_ip',
      desc: '',
      args: [],
    );
  }

  /// `Ce champ nécessite une chaîne de date valide.`
  String get this_field_requires_a_valid_date_string {
    return Intl.message(
      'Ce champ nécessite une chaîne de date valide.',
      name: 'this_field_requires_a_valid_date_string',
      desc: '',
      args: [],
    );
  }

  /// `Les mots de passe ne correspondent pas.`
  String get passwords_do_not_match {
    return Intl.message(
      'Les mots de passe ne correspondent pas.',
      name: 'passwords_do_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Mettre a jour l'adresse email`
  String get update_email_address {
    return Intl.message(
      'Mettre a jour l\'adresse email',
      name: 'update_email_address',
      desc: '',
      args: [],
    );
  }

  /// `Changer de mot de passe`
  String get change_password {
    return Intl.message(
      'Changer de mot de passe',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Mettre à jour mes informations`
  String get update_my_information {
    return Intl.message(
      'Mettre à jour mes informations',
      name: 'update_my_information',
      desc: '',
      args: [],
    );
  }

  /// `L'adresse e-mail a été mise à jour avec succès.`
  String get email_address_has_been_successfully_updated {
    return Intl.message(
      'L\'adresse e-mail a été mise à jour avec succès.',
      name: 'email_address_has_been_successfully_updated',
      desc: '',
      args: [],
    );
  }

  /// `Le mot de passe a été mis à jour avec succès.`
  String get password_has_been_successfully_updated {
    return Intl.message(
      'Le mot de passe a été mis à jour avec succès.',
      name: 'password_has_been_successfully_updated',
      desc: '',
      args: [],
    );
  }

  /// `Vos informations ont été mises à jour avec succès.`
  String get your_information_has_been_successfully_updated {
    return Intl.message(
      'Vos informations ont été mises à jour avec succès.',
      name: 'your_information_has_been_successfully_updated',
      desc: '',
      args: [],
    );
  }

  /// `Explorer`
  String get explore {
    return Intl.message(
      'Explorer',
      name: 'explore',
      desc: '',
      args: [],
    );
  }

  /// `Continuer en tant qu'invité`
  String get continue_as_a_guest {
    return Intl.message(
      'Continuer en tant qu\'invité',
      name: 'continue_as_a_guest',
      desc: '',
      args: [],
    );
  }

  /// `depuis`
  String get suffix_ago {
    return Intl.message(
      'depuis',
      name: 'suffix_ago',
      desc: '',
      args: [],
    );
  }

  /// `à partir de maintenant`
  String get suffix_from_now {
    return Intl.message(
      'à partir de maintenant',
      name: 'suffix_from_now',
      desc: '',
      args: [],
    );
  }

  /// `un instant`
  String get less_than_one_minute {
    return Intl.message(
      'un instant',
      name: 'less_than_one_minute',
      desc: '',
      args: [],
    );
  }

  /// `une minute`
  String get about_a_minute {
    return Intl.message(
      'une minute',
      name: 'about_a_minute',
      desc: '',
      args: [],
    );
  }

  /// `{hours} heures`
  String hours(Object hours) {
    return Intl.message(
      '$hours heures',
      name: 'hours',
      desc: '',
      args: [hours],
    );
  }

  /// `{minutes} minutes`
  String minutes(Object minutes) {
    return Intl.message(
      '$minutes minutes',
      name: 'minutes',
      desc: '',
      args: [minutes],
    );
  }

  /// `{seconds} seconds`
  String seconds(Object seconds) {
    return Intl.message(
      '$seconds seconds',
      name: 'seconds',
      desc: '',
      args: [seconds],
    );
  }

  /// `environ une heure`
  String get about_an_hour {
    return Intl.message(
      'environ une heure',
      name: 'about_an_hour',
      desc: '',
      args: [],
    );
  }

  /// `un jour`
  String get a_day {
    return Intl.message(
      'un jour',
      name: 'a_day',
      desc: '',
      args: [],
    );
  }

  /// `{days} jours`
  String days(Object days) {
    return Intl.message(
      '$days jours',
      name: 'days',
      desc: '',
      args: [days],
    );
  }

  /// `environ un mois`
  String get about_a_month {
    return Intl.message(
      'environ un mois',
      name: 'about_a_month',
      desc: '',
      args: [],
    );
  }

  /// `{months} mois`
  String months(Object months) {
    return Intl.message(
      '$months mois',
      name: 'months',
      desc: '',
      args: [months],
    );
  }

  /// `à peu près un an`
  String get about_a_year {
    return Intl.message(
      'à peu près un an',
      name: 'about_a_year',
      desc: '',
      args: [],
    );
  }

  /// `{years} ans`
  String years(Object years) {
    return Intl.message(
      '$years ans',
      name: 'years',
      desc: '',
      args: [years],
    );
  }

  /// `Top Radios`
  String get featured_radios {
    return Intl.message(
      'Top Radios',
      name: 'featured_radios',
      desc: '',
      args: [],
    );
  }

  /// `Top Podcasts`
  String get featured_podcasts {
    return Intl.message(
      'Top Podcasts',
      name: 'featured_podcasts',
      desc: '',
      args: [],
    );
  }

  /// `Chercher`
  String get search {
    return Intl.message(
      'Chercher',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Favoris`
  String get favorites {
    return Intl.message(
      'Favoris',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `Radios Favorites`
  String get favorite_radios {
    return Intl.message(
      'Radios Favorites',
      name: 'favorite_radios',
      desc: '',
      args: [],
    );
  }

  /// `Liste des radios`
  String get radio_stations {
    return Intl.message(
      'Liste des radios',
      name: 'radio_stations',
      desc: '',
      args: [],
    );
  }

  /// `Évaluer`
  String get evaluate {
    return Intl.message(
      'Évaluer',
      name: 'evaluate',
      desc: '',
      args: [],
    );
  }

  /// `Visitez notre site Internet`
  String get visit_our_website {
    return Intl.message(
      'Visitez notre site Internet',
      name: 'visit_our_website',
      desc: '',
      args: [],
    );
  }

  /// `Une nouvelle version est disponible`
  String get new_version_title {
    return Intl.message(
      'Une nouvelle version est disponible',
      name: 'new_version_title',
      desc: '',
      args: [],
    );
  }

  /// `Pour utiliser l'application, vous devez mettre à jour la version.`
  String get new_version_description {
    return Intl.message(
      'Pour utiliser l\'application, vous devez mettre à jour la version.',
      name: 'new_version_description',
      desc: '',
      args: [],
    );
  }

  /// `Fermer l'application`
  String get close_application {
    return Intl.message(
      'Fermer l\'application',
      name: 'close_application',
      desc: '',
      args: [],
    );
  }

  /// `Mettez à jour maintenant`
  String get update_now {
    return Intl.message(
      'Mettez à jour maintenant',
      name: 'update_now',
      desc: '',
      args: [],
    );
  }

  /// `Temps de veille`
  String get sleeping_time {
    return Intl.message(
      'Temps de veille',
      name: 'sleeping_time',
      desc: '',
      args: [],
    );
  }

  /// `Fermet`
  String get close {
    return Intl.message(
      'Fermet',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Set`
  String get set {
    return Intl.message(
      'Set',
      name: 'set',
      desc: '',
      args: [],
    );
  }

  /// `À propos de nous`
  String get about_us {
    return Intl.message(
      'À propos de nous',
      name: 'about_us',
      desc: '',
      args: [],
    );
  }

  /// `Politique de confidentialité`
  String get privacy_policy {
    return Intl.message(
      'Politique de confidentialité',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Termes et conditions`
  String get terms_and_conditions {
    return Intl.message(
      'Termes et conditions',
      name: 'terms_and_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Liste des Podcasts`
  String get podcasts {
    return Intl.message(
      'Liste des Podcasts',
      name: 'podcasts',
      desc: '',
      args: [],
    );
  }

  /// `Aucune donnée disponible.`
  String get no_data_found {
    return Intl.message(
      'Aucune donnée disponible.',
      name: 'no_data_found',
      desc: '',
      args: [],
    );
  }

  /// `Oups!`
  String get whoops {
    return Intl.message(
      'Oups!',
      name: 'whoops',
      desc: '',
      args: [],
    );
  }

  /// `Annuler`
  String get cancel {
    return Intl.message(
      'Annuler',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Catégories`
  String get categories {
    return Intl.message(
      'Catégories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Arrêtez`
  String get stop {
    return Intl.message(
      'Arrêtez',
      name: 'stop',
      desc: '',
      args: [],
    );
  }

  /// `Rafraîchir`
  String get refresh {
    return Intl.message(
      'Rafraîchir',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Blogs`
  String get blogs {
    return Intl.message(
      'Blogs',
      name: 'blogs',
      desc: '',
      args: [],
    );
  }

  /// `Écrire un commentaire`
  String get write_a_comment {
    return Intl.message(
      'Écrire un commentaire',
      name: 'write_a_comment',
      desc: '',
      args: [],
    );
  }

  /// `Commentaires`
  String get comments {
    return Intl.message(
      'Commentaires',
      name: 'comments',
      desc: '',
      args: [],
    );
  }

  /// `Commentaire`
  String get comment {
    return Intl.message(
      'Commentaire',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Supprimer`
  String get delete {
    return Intl.message(
      'Supprimer',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `ajouter`
  String get ad {
    return Intl.message(
      'ajouter',
      name: 'ad',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}